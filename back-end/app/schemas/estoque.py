from pydantic import BaseModel


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
