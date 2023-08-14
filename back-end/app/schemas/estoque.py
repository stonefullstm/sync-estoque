from pydantic import BaseModel


class EstoqueSchema(BaseModel):
    controle: int
    produto: str
    unidade: str
    qtde: int


class EstoqueList(BaseModel):
    products: list[EstoqueSchema]
