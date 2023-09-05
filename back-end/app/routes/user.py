from fastapi import APIRouter, Depends, HTTPException, status
from sqlmodel import Session, select

from app.models.user import Usuario
from app.schemas.user import UserAuth, UserOut
from app.schemas.token import TokenSchema
from app.database.db import get_session
from app.utils.utils import (
    get_hashed_password,
    create_access_token,
    create_refresh_token,
    verify_password
)


router = APIRouter(prefix='/user')


@router.post('/',
             summary='Create a user',
             response_model=UserOut,
             status_code=201,
             tags=['Usuário']
             )
def create_user(
    user: UserAuth,
    session: Session = Depends(get_session)
):
    usuario = Usuario()
    usuario.username = user.username
    usuario.password = get_hashed_password(user.password)
    session.add(usuario)
    session.commit()
    session.refresh(usuario)
    return usuario


@router.post(
        '/login', summary="Create access and refresh tokens for user",
        response_model=TokenSchema,
        tags=['Usuário'])
def login(user: UserAuth, session: Session = Depends(get_session)):

    user_found = session.exec(
        select(Usuario).where(Usuario.username == user.username)).first()
    if user_found is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Incorrect username"
        )

    hashed_pass = user_found.password
    if not verify_password(user.password, hashed_pass):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Incorrect password"
        )

    return {
        "access_token": create_access_token(user.username),
        "refresh_token": create_refresh_token(user.username),
    }
