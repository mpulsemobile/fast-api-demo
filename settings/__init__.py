from pydantic import BaseModel, BaseSettings
from .database import database_settings, DatabaseSettings
from .logging import logging_settings, LoggingSettings
from environs import Env

env = Env()
env.read_env()


class Settings(BaseSettings):
    LOG_LEVEL: str = env.str("LOG_LEVEL", "INFO")
    DATABASE: DatabaseSettings = database_settings
    LOG_SETTINGS: dict = logging_settings.config


settings = Settings()
