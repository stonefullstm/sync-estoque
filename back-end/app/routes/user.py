from fastapi import APIRouter, Depends
from sqlmodel import Session, select, delete

from app.models.user import Usuario
from app.schemas.user import UserAuth, UserOut
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
