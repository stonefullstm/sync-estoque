from sqlmodel import SQLModel, Field


class Estoque(SQLModel, table=True):

    controle: int = Field(primary_key=True)
    produto: str = Field(max_length=100)
    unidade: str = Field(max_length=5)
    qtde: int = Field()
