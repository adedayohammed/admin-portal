#!/bin/bash
set -e

source /app/.venv/bin/activate

echo "⏳ Waiting for PostgreSQL to be ready..."
until pg_isready -h "${POSTGRES_HOST:-db}" -p "${POSTGRES_PORT:-5432}" -U "$POSTGRES_USER" -q; do
    echo "  PostgreSQL not ready yet — retrying in 2s..."
    sleep 2
done
echo "✅ PostgreSQL is ready."

echo "📦 Applying database migrations..."
python manage.py migrate --noinput

echo "🗂️  Collecting static files..."
python manage.py collectstatic --noinput

echo "🚀 Starting Gunicorn..."
exec gunicorn \
    --bind 0.0.0.0:8000 \
    --workers "${GUNICORN_WORKERS:-3}" \
    --threads "${GUNICORN_THREADS:-2}" \
    --worker-class gthread \
    --timeout 120 \
    --access-logfile /app/logs/gunicorn-access.log \
    --error-logfile /app/logs/gunicorn-error.log \
    --log-level info \
    admin.wsgi:application