from fastapi import APIRouter, Depends
# from sqlalchemy.exc import NoResultFound
from sqlmodel import Session, select, delete

from app.models.estoque import Estoque
from app.schemas.estoque import EstoqueList, EstoqueSchema, ProductsList
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
             response_model=EstoqueList,
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
    products.products = session.exec(
        select(Estoque).limit(10))
    return {'products': products}
