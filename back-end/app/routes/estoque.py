from fastapi import APIRouter, Depends
# from sqlalchemy.exc import NoResultFound
from sqlmodel import Session, select

from app.models.estoque import Estoque
from app.schemas.estoque import EstoqueList, EstoqueSchema
from app.database.db import get_session

router = APIRouter(prefix='/estoque')


@router.get(
        '/',
        summary='Returns all products.',
        response_model=EstoqueList,
        tags=['Estoque'])
def read_products(
    session: Session = Depends(get_session)
):
    products = session.exec(select(Estoque)).all()
    return {'products': products}


@router.post('/',
             summary='Create/Update a product.',
             response_model=EstoqueSchema,
             status_code=201,
             tags=['Estoque'])
def create_product(
    product: Estoque,
    session: Session = Depends(get_session)
):
    session.add(product)
    session.commit()
    session.refresh(product)
    return product
