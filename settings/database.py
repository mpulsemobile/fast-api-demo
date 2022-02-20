from environs import Env
from pydantic import BaseSettings

env = Env()
env.read_env()


class DatabaseSettings(BaseSettings):
    SQLALCHEMY_DATABASE_URL = f'postgresql://{env.str("PG_USERNAME")}:{env.str("PG_USERNAME")}@{env.str("PG_HOST")}/{env.str("PG_NAME")}'


database_settings = DatabaseSettings()
