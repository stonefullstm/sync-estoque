from pydantic import BaseModel


class UserOut(BaseModel):
    id: int
    username: str


class UserAuth(BaseModel):
    username: str
    password: str
