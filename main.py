from fastapi import FastAPI
import logging
from logging import config
from settings import settings
from api import api_router


app = FastAPI()
app.include_router(api_router)
logging.config.dictConfig(settings.LOG_SETTINGS)
