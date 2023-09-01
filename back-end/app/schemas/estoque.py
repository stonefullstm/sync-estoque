from pydantic import BaseModel
from app.models.estoque import Estoque


class EstoqueSchema(BaseModel):
    controle: int
    produto: str
    unidade: str
    qtde: float
    precocusto: float
    precovenda: float
    grupo: str
    fornecedor: str
    ativo: str


class EstoqueUpdateSchema(BaseModel):
    produto: str
    unidade: str
    qtde: float


class EstoqueList(BaseModel):
    products: list[EstoqueSchema]


class ProductsList(BaseModel):
    products: list[Estoque]
