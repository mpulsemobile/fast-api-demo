#!/bin/bash
alembic upgrade head
python -m uvicorn main:app --reload --port 3000 --host 0.0.0.0