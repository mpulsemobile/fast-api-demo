from fastapi import APIRouter
from .routes import users

version_router = APIRouter(prefix="/v1")
version_router.include_router(users.user_router)
