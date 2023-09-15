from typing import Annotated
from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm, OAuth2PasswordBearer
from sqlmodel import Session, select
from jose import JWTError

from app.models.user import Usuario
from app.schemas.user import UserOut, UserAuth
from app.schemas.token import Token, TokenData, AccessToken, RefreshToken
from app.database.db import get_session
from app.utils.utils import (
    get_password_hash,
    create_access_token,
    create_refresh_token,
    decode_jwt,
    decode_refresh_jwt,
    verify_password
)

ACCESS_TOKEN_EXPIRE_MINUTES = 15
REFRESH_TOKEN_EXPIRE_MINUTES = 60 * 24

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="user/login")

router = APIRouter(prefix='/user')


async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)],
                           session: Session = Depends(get_session)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = decode_jwt(token)
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except JWTError:
        raise credentials_exception
    user = session.exec(
        select(Usuario).where(Usuario.username == token_data.username)).first()
    if user is None:
        raise credentials_exception
    return user


@router.post('/',
             summary='Create a user',
             response_model=UserOut,
             status_code=201,
             tags=['Usuário']
             )
async def create_user(
    user: UserAuth,
    session: Session = Depends(get_session)
):
    usuario = Usuario()
    usuario.username = user.username
    usuario.password = get_password_hash(user.password)
    session.add(usuario)
    session.commit()
    session.refresh(usuario)
    return usuario


@router.post(
        '/login', summary="Create access token for user",
        response_model=Token,
        tags=['Usuário'])
async def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
                session: Session = Depends(get_session)):

    user_found = session.exec(
        select(Usuario).where(Usuario.username == form_data.username)).first()
    if user_found is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Incorrect username"
        )

    hashed_pass = user_found.password
    if not verify_password(form_data.password, hashed_pass):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Incorrect password"
        )

    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    refresh_token_expires = timedelta(minutes=REFRESH_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user_found.username}, expires_delta=access_token_expires
    )
    refresh_token = create_refresh_token(
        data={"sub": user_found.username}, expires_delta=refresh_token_expires
    )

    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"}


@router.get("/me/",
            response_model=UserOut,
            tags=['Usuário'], summary='Returns user data')
async def read_users_me(
    current_user: Annotated[Usuario, Depends(get_current_user)]
):
    return current_user


@router.post(
        '/refresh', summary="Get a new access token",
        response_model=AccessToken,
        tags=['Usuário'])
def get_new_token(
        refresh_token: RefreshToken, session: Session = Depends(get_session)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = decode_refresh_jwt(refresh_token.refresh_token)
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except JWTError:
        raise credentials_exception
    user = session.exec(
        select(Usuario).where(Usuario.username == token_data.username)).first()
    if user is None:
        raise credentials_exception
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}
