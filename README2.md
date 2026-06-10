admin-partner-portal

CI/CD pipeline for the Admin & Partner Portal backend — a Python application to be deployed via Docker Compose.

Overview
•	Python backend application containerised with Docker
•	Pipeline covers linting, testing, and image build
•	Deployment not yet live — server still needs to be bootstrapped

Docker
Image
•	Base image: python:3.11.9-slim
•	The CMD uses entrypoint.sh, which runs database migrations on startup — review this script before deploying

Compose Stack (planned)
When the server is ready, the application will be deployed as part of a Docker Compose stack. The stack will include:
•	PostgreSQL database
•	Nginx (reverse proxy)
•	Redis
•	RabbitMQ
•	Celery worker
•	admin-partner-be (this service)

CI/CD Pipeline
The GitHub Actions pipeline:
•	Runs linting
•	Runs tests
•	Builds and pushes the Docker image

Dependencies
•	PostgreSQL
•	RabbitMQ
•	Redis
•	Celery

Environment Variables
See the repo README for the full .env reference. Variables must be configured before bringing up the compose stack.

Port
Container port: 8000  (Nginx handles external routing)

Server Bootstrap
The server has not yet been set up. Install Docker and Docker Compose before deploying.

Known Improvements
•	Create a develop branch and configure pipeline triggers (currently no trigger is set)
•	Parameterise pipeline inputs using GitHub Actions variables
•	Pin the Ubuntu runner to a specific version instead of latest
•	Review the entrypoint.sh CMD and confirm migration behaviour is correct for production