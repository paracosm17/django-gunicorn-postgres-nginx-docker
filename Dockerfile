FROM python:3.12.2-slim

ENV PYTHONUNBUFFERED=1

RUN apt-get update --yes --quiet && apt-get install --yes --quiet --no-install-recommends \
    netcat-openbsd \
    build-essential \
    libpq-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libwebp-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /app/
RUN pip install -r /app/requirements.txt

COPY ./docker-entrypoint.sh .
RUN chmod +x /app/docker-entrypoint.sh

COPY . /app/

ENTRYPOINT ["sh", "/app/docker-entrypoint.sh"]