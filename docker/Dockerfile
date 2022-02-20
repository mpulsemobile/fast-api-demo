FROM python:3.10 as api

WORKDIR /app
COPY Pipfile .
COPY Pipfile.lock .

RUN pip install pipenv

RUN pipenv install --system --deploy

COPY . .
RUN chmod a+x docker/entrypoint.sh

ENTRYPOINT ['/app/docker/entrypoint.sh']