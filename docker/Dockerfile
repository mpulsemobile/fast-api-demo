FROM python:3.10 as api

WORKDIR /app
COPY Pipfile .
COPY Pipfile.lock .

RUN pip install pipenv

RUN pipenv install --system --deploy

COPY /api ./api
COPY /docker ./docker
COPY /tests ./tests
COPY /migrations ./migrations
COPY /models ./models
COPY /settings ./settings
COPY main.py .
COPY alembic.ini .

RUN chmod a+x docker/entrypoint.sh
ENTRYPOINT ["/app/docker/entrypoint.sh"]