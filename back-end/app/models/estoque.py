from sqlmodel import SQLModel, Field


class Estoque(SQLModel, table=True):

    controle: int = Field(primary_key=True)
    produto: str = Field(max_length=100)
    unidade: str = Field(max_length=5)
    qtde: int = Field()
    precocusto: float = Field()
    precovenda: float = Field()
    grupo: str = Field(max_length=100)
    fornecedor: str = Field(max_length=100)
    ativo: str = Field(max_length=3)
