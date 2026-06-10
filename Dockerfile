# ── Stage 1: Builder ──────────────────────────────────────────────────────────
# Install deps in an isolated stage so the final image has no build tools
FROM python:3.11.9-slim AS builder

# Prevents Python from writing .pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VERSION=2.1.3 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1

# Install system build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="$POETRY_HOME/bin:$PATH"

WORKDIR /app

# Copy only dependency files first (better layer caching)
# If pyproject.toml hasn't changed, this layer is reused even if code changed
COPY pyproject.toml poetry.lock* ./

# Install dependencies into .venv inside /app
RUN poetry install --no-root


# ── Stage 2: Runtime ──────────────────────────────────────────────────────────
FROM python:3.11.9-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH"

# Runtime system dependencies only (no compilers)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    postgresql-client \  
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for security — never run as root in containers
RUN groupadd --gid 1001 appgroup && \
    useradd --uid 1001 --gid appgroup --no-create-home appuser

WORKDIR /app

# Copy the virtualenv from builder (this avoids needing Poetry in runtime)
COPY --from=builder /app/.venv /app/.venv

# Copy application source
COPY --chown=appuser:appgroup . .

# Create directories for static/media files and logs
RUN mkdir -p /app/staticfiles /app/media /app/logs && \
    chown -R appuser:appgroup /app/staticfiles /app/media /app/logs

# Entrypoint handles migrations + static files before starting Gunicorn
COPY --chown=appuser:appgroup entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to non-root user
USER appuser

# Expose the Gunicorn port (Nginx will proxy to this)
EXPOSE 8000

CMD ["/entrypoint.sh"]