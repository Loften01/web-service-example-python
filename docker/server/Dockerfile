FROM python:3.12-slim
LABEL authors="Rosa Serai <loften@tutanota.de>"

RUN pip install poetry --root-user-action ignore

WORKDIR /app

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

COPY . .
CMD ["poetry", "run", "python3.12", "-m", "server.main"]
