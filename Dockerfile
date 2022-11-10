# pull official base image
FROM python:3.11.0-slim-buster as base

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# temp stage
FROM base AS builder

# install system dependencies
RUN apt-get update && \
  apt-get install -y --no-install-recommends gcc

# install python dependencies
COPY ./requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt

# final stage
FROM base AS runtime

# install dependencies
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache /wheels/*

RUN addgroup --gid 1001 --system app && \
  adduser --no-create-home --shell /bin/false --disabled-password --uid 1001 --system --group app
USER app

# copy project files
COPY ./main.py ./entrypoint.sh ./

# run entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]