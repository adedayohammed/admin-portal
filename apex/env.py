import os
from pathlib import Path

from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent


def load_environment():
    load_dotenv(dotenv_path=BASE_DIR / ".env")

    env = os.environ.get("DJANGO_ENV")

    os.environ.setdefault("DJANGO_SETTINGS_MODULE", f"apex.settings.{env}")