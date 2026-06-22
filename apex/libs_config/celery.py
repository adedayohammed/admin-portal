import logging.config

from celery import Celery
from django.conf import settings

from apex.env import load_environment

load_environment()


app = Celery("apex")

# Load config from Django settings using CELERY_ prefix
app.config_from_object("django.conf:settings", namespace="CELERY")

# Autodiscover tasks in all installed apps
app.autodiscover_tasks()


# Use the application logging configuration
logging.config.dictConfig(settings.LOGGING)