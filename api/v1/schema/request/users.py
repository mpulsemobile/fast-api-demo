from pydantic import BaseModel, validator


class CreateUserRequest(BaseModel):
    name: str

    @validator("name")
    def name_cannot_be_richie(cls, v):
        if v == "richie":
            raise ValueError("Cannot be named Richie")
        return v
