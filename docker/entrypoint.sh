#!/bin/bash
alembic upgrade head
UVICORN_HOST=${UVICORN_HOST:-0.0.0.0}
UVICORN_PORT=${UVICORN_HOST:-3000}
UVICORN_PORT=${UVICORN_WORKERS:-1}
python -m uvicorn main:app --reload --port $UVICORN_PORT --host $UVICORN_HOST --workers $UVICORN_WORKERS