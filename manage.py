#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    settings_file = os.getenv("DJANGO_SETTINGS") if os.getenv("DJANGO_SETTINGS") == "production" else "dev"
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", f"djangodeploy.settings.{settings_file}")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
