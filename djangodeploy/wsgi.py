"""
WSGI config for djangodeploy project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.0/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

settings_file = os.getenv("DJANGO_SETTINGS") if os.getenv("DJANGO_SETTINGS") == "production" else "dev"
os.environ.setdefault("DJANGO_SETTINGS_MODULE", f"djangodeploy.settings.{settings_file}")

application = get_wsgi_application()
