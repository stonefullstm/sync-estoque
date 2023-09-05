from sqlmodel import SQLModel, Field
from typing import Optional


class Usuario(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    username: str = Field(..., min_length=10, max_length=100)
    password: str = Field(..., min_length=8)
