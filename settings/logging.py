from environs import Env
from pydantic import BaseSettings
import logging
import sys

env = Env()
env.read_env()


class LoggingSettings(BaseSettings):
    config: dict = {
        "version": 1,
        "root": {
            "handlers": ["console"],
            "level": env("LOG_LEVEL", "INFO"),
        },
        "handlers": {
            "console": {
                "formatter": "default",
                "class": "logging.StreamHandler",
                "level": env("LOG_LEVEL", "INFO"),
            },
        },
        "formatters": {
            "default": {
                "format": "[%(asctime)s] [%(name)s|%(processName)s|%(threadName)s|%(filename)s:%(funcName)s:%(lineno)d] [%(levelname)s] %(message)s",
                "datefmt": "%Y-%m-%d %H:%M:%S",
            }
        },
        "loggers": {
            "uvicorn": {
                "handlers": ["console"],
                "level": env("LOG_LEVEL", "INFO"),
                "propagate": False,
            },
            "uvicorn.error": {
                "handlers": ["console"],
                "level": env("LOG_LEVEL", "INFO"),
                "propagate": False,
            },
            "uvicorn.access": {
                "handlers": ["console"],
                "level": env("LOG_LEVEL", "INFO"),
                "propagate": False,
            },
        },
    }


logging_settings = LoggingSettings()
