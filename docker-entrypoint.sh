#!/bin/bash

while ! nc -z $DB_HOST $DB_PORT; do
  echo "Waiting for PostgreSQL to start..."
  sleep 1
done
echo "PostgreSQL started"

python manage.py collectstatic --noinput --clear
python manage.py makemigrations --noinput
python manage.py migrate --noinput

DJANGO_SUPERUSER_USERNAME=$DJANGO_USER \
DJANGO_SUPERUSER_PASSWORD=$DJANGO_PASSWORD \
DJANGO_SUPERUSER_EMAIL=$DJANGO_EMAIL \
python manage.py createsuperuser --noinput

gunicorn --bind 0.0.0.0:8000 djangodeploy.wsgi:application

exec "$@"