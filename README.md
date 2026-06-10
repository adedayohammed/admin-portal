# ADMIN PORTAL APP

---

This is an internal organization application i.e only authorized users that have access can use this application.


> #### **NOTE 📝**: This application has no sign up feature, users can only sign in and be redirected to their respective dashboards.

## WORKFLOW

```
User Login → JWT Token → Frontend App → Backend API endpoints
```

---

# 🛠️ Admin Portal Django Project Setup with Poetry

This guide walks you through setting up and running a Django project using [Poetry](https://python-poetry.org/), a tool for dependency management and packaging in Python.

---

## 📦 Prerequisites

- Python 3.11 or higher
- Git (optional but recommended)
- Poetry (we’ll install it below if not already installed)

---

## 🚀 Step 1: Installing Poetry

If Poetry is not installed on your machine, run the following command:

```bash
curl -sSL https://install.python-poetry.org | python3 -
```
`
📝 You may need to restart your terminal or run export to use the poetry command.

```bash
PATH="$HOME/.local/bin:$PATH" 
```

or you can install poetry using `pipx` or `pip` install command.

Check the version:

```bash
poetry --version
```

## 📂 STEP 2: Clone the Project via SSH (recommended)

```bash
git clone git@github.com-<your alias here>:avetiumconsult/admin-partner-be.git  # if you setup an alias

cd your-django-project
```
OR

```bash
git clone git@github.com:avetiumconsult/admin-partner-be.git  # if you did not setup alias

cd your django-project
```

### Or Clone the Project via HTTPS

```bash
git clone https://github.com/avetiumconsult/admin-partner-be.git

cd your-django-project
```



## 🧰 Step 3: Set Up the Environment 

#### With Poetry

1. Install project dependencies:

```bash
poetry install

```

2. Activate the virtual environment:

```bash
poetry shell
```

3. (Optional) If you're not using poetry shell, you can run any command within the virtual environment using:

```bash
poetry run python manage.py runserver
```

#### With Python

1. Create virtual environment (Windows):

```commandline
python -m venv '<name-of-your-env>'

```
Ubuntu (Debian)
```commandline
python3 -m venv '<name-of-your-env>'

```

2. Activate the virtual environment (Windows):

```commandline
<name-fo-your-venv>\Scripts\activate 
```
Ubuntu (Debian)
```commandline
source <name-fo-your-venv>/bin/activate 
```

3. Install the dependencies in your virtual environment

```commandline
poetry install
```

4. (Optional) If you're not using poetry shell, you can run any command within the virtual environment using:

```bash
poetry run python manage.py runserver
```

Without poetry
```bash
python manage.py runserver
```


## ⚙️ Step 4: Set Up Django

1. Set up `env` file in the django project

```bash
SECRET_KEY=<your secret key>  # generate any secret key
DEBUG=False  # is on development server set DEBUG as True (to view any error on the browser)
ALLOWED_HOSTS=<your domain here> or use localhost or 127.0.0.1 (on development server) # for example set it like this: 'ALLOWED_HOSTS=yourdomainname.com,localhost,127.0.0.1'
```

2. Create a migrations:

```bash
python manage.py makemigrations
```

3. Apply migrations

```bash
python manage.py migrate
```

4. Run the development server:

```bash
python manage.py runserver
```

Access the project in your browser at http://127.0.0.1:8000 or at the domain name set

-------

# 🗄️ Database Setup

Database tool to use
1. Sqlite3
2. Postgresql

> #### **NOTE 📝**: You can use other database tools, just have to set them accordingly. See Django Database setup.

The database setup is as follows on production/staging.
#### Example

```commandline
POSTGRES_USER=local
POSTGRES_PASSWORD=1234
POSTGRES_HOST=localhost
POSTGRES_PORT=5465
POSTGRES_DB=localdB
POSTGRES_SSLMODE=require
```

### Database Migration
Any change to the model schema eg. adding/deleting/editing a model field, always run the following
to take effect:

```python
python manage.py makemigrations
```

followed by

```python
python manage.py migrate
```

---

## Environment Variables

```text
SECRET_KEY=<secret key for the application>
DEBUG=False  # always set this to False on staging & production environments
ALLOWED_HOSTS=<admin portal backend url>

FRONTEND_BASE_URL=<admin portal frontend url>
PARTNER_PORTAL_WEBHOOK_URL=<partner portal app webhook>

POSTGRES_USER=<database user>
POSTGRES_PASSWORD=<database password>
POSTGRES_HOST=<database host>
POSTGRES_PORT=<database port>
POSTGRES_DB=<database name>
POSTGRES_SSLMODE=require  # set this to require

MAILTRAP_TOKEN=<mailtrap token>
EMAIL_SENDER=<mailtrap sender name>
EMAIL_SENDER_NAME=<mail title/header>

CELERY_BROKER_URL=redis://localhost:6379/0 # <- Ensure you set the id specific to an environment

DJANGO_ENV=<environment>
LOG_DIR_PATH=<path to your log files>
```

---

# 🧪 How to deploy on staging/production environment (via Linux CLI)

### PREREQUISITES

1. Ensure a user is created, ownership and permissions have been given to the user.
2. Nginx configuration file has been setup (Documentation will be provided).
3. GIT is installed.
4. REDIS server is installed and active.

```bash
sudo systemctl status redis-server  # to see redis server status
```

5. POETRY is installed.

```bash
poetry --version
```

### 🔑 STEP-BY-STEP
1. Create a directory, and clone the project (SSH is recommended)
2. Create a virtual environment and activate it.
3. Run the poetry command to install the dependencies
4. Setup gunicorn configurations (Documentation will be provided in details on how to setup gunicorn configurations.)
5. Setup Celery configurations.
6. Add logging path in the `.env` .
7. Activate the gunicorn service file.

```bash
sudo systemctl restart "name of gunicorn service file"
```

8. Activate the celery service file

```bash
sudo systemctl restart "name of celery service file"
```

## ✅ TIPS

1. Restart and check the status of nginx after setup
2. Restart and check the gunicorn service, if there is a change in the configuration file.
3. Restart the gunicorn service, if a migration was done or a change in the application to apply effect.