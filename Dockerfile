FROM python:3.8

ENV APP_HOME /app
WORKDIR $APP_HOME

COPY pyproject.toml poetry.lock ./

RUN pip install poetry
RUN poetry config virtualenvs.create false \
    && poetry install

COPY app.py .

CMD gunicorn --bind :${PORT-8080} --workers 1 --threads 8 app:app
