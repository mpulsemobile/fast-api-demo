from pydantic import BaseModel


class CreateUser(BaseModel):
    name: str
    id: int

    class Config:
        orm_mode = True


class GetUsers(BaseModel):
    data: list[CreateUser]

    class Config:
        orm_mode = True
