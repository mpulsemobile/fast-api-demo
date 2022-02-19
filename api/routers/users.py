import logging

from fastapi import APIRouter, Depends
import api.schema.requests.users as request_schema
import api.schema.response.users as response_schema
from sqlalchemy.orm import Session
from models import get_db, user as user_model


router = APIRouter()


@router.get("/users", tags=["users"], response_model=response_schema.GetUsers)
async def get_users(db: Session = Depends(get_db)):
    users = db.query(user_model.User).all()
    return response_schema.GetUsers(data=users)


@router.post("/users", tags=["users"], response_model=response_schema.CreateUser)
async def create_user(user: request_schema.CreateUser, db: Session = Depends(get_db)):
    logging.info("Creating User")
    db_user = user_model.User(name=user.name)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
