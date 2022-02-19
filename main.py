from fastapi import FastAPI
from api.routers import users
import logging
from logging import config
from settings import settings


app = FastAPI()
app.include_router(users.router)
logging.config.dictConfig(settings.LOG_SETTINGS)


@app.get("/")
async def root():
    return {"message": "Hello World"}
