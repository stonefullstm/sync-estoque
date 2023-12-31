from fastapi import APIRouter, Depends
from sqlmodel import Session, select, delete
from typing import Annotated

from app.models.estoque import Estoque
from app.models.user import Usuario
from app.schemas.estoque import EstoqueList, EstoqueSchema, ProductsList
from app.database.db import get_session
from app.routes.user import get_current_active_user

router = APIRouter(prefix='/estoque')


@router.get(
        '/',
        summary='Returns all products.',
        response_model=EstoqueList,
        tags=['Estoque'])
async def read_products(
    current_user: Annotated[Usuario, Depends(get_current_active_user)],
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
    produto: Estoque = session.exec(select(Estoque).where(
        Estoque.controle == product.controle)).first()
    if not produto:
        session.add(product)
        session.commit()
        session.refresh(product)
        return product
    else:
        produto.produto = product.produto
        produto.unidade = product.unidade
        produto.qtde = product.qtde
        produto.grupo = product.grupo
        produto.fornecedor = product.fornecedor
        produto.precocusto = product.precocusto
        produto.precovenda = product.precovenda
        produto.ativo = product.ativo
        session.add(produto)
        session.commit()
        session.refresh(produto)
        return produto


@router.post('/lista',
             summary='Create/Update a product list.',
             status_code=201,
             tags=['Estoque'])
def create_product_list(
    products: ProductsList,
    session: Session = Depends(get_session)
):
    session.exec(delete(Estoque))
    session.commit()
    session.add_all(products.products)
    session.commit()

    return 'Products succefully added'
