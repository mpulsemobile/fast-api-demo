import logging
from fastapi import APIRouter, Depends
import api.v1.schema.request.users as request_schema
import api.v1.schema.response.users as response_schema
from sqlalchemy.orm import Session
from models import get_db, user as user_model


user_router = APIRouter(prefix="/users")


@user_router.get("/", tags=["users"], response_model=response_schema.GetUsersResponse)
async def get_users(db: Session = Depends(get_db)):
    users = db.query(user_model.User).all()
    return response_schema.GetUsersResponse(data=users)


@user_router.post(
    "/", tags=["users"], response_model=response_schema.CreateUserResponse
)
async def create_user(
    user: request_schema.CreateUserRequest, db: Session = Depends(get_db)
):
    logging.info("Creating User")
    db_user = user_model.User(name=user.name)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
