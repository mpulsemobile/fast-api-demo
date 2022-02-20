from pydantic import BaseModel


class CreateUserResponse(BaseModel):
    name: str
    id: int

    class Config:
        orm_mode = True


class GetUsersResponse(BaseModel):
    data: list[CreateUserResponse]

    class Config:
        orm_mode = True
