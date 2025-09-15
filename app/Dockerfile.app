#### Without multistage ##########
# FROM python:3.9

# WORKDIR /app

# COPY . .
# COPY templates/ templates/

# RUN pip install --no-cache-dir Flask mysql-connector-python gunicorn flask_sqlalchemy flask-bcrypt PyJWT pymysql cryptography


# CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--timeout", "120", "app:app"]


#### With multistage ##############
# # ---- Base Stage ----
# FROM python:3.9 AS base
# WORKDIR /app
# COPY requirements.txt .
# RUN pip install --no-cache-dir Flask mysql-connector-python gunicorn flask_sqlalchemy flask-bcrypt PyJWT pymysql cryptography

# # ---- Build Stage ----
# FROM python:3.9 AS builder
# WORKDIR /app
# COPY . .
# COPY templates/ templates/
# RUN pip install --no-cache-dir Flask mysql-connector-python gunicorn flask_sqlalchemy flask-bcrypt PyJWT pymysql cryptography

# # ---- Final Production Image ----
# FROM python:3.9-slim AS final
# WORKDIR /app

# # Copy the application code
# COPY --from=builder /app /app

# # Copy installed dependencies from the builder stage
# COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
# COPY --from=builder /usr/local/bin /usr/local/bin

# # Expose port
# EXPOSE 5000

# # Set entrypoint
# CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--timeout", "120", "app:app"]

##### with multistage and security features#############

# ---- Base Stage ----
FROM python:3.9-slim AS base

# Set work directory
WORKDIR /app

# Create a non-root user
RUN groupadd -r appuser && useradd --no-log-init -r -g appuser appuser

# Set umask for better security
RUN umask 077

# Copy requirements file and install dependencies as root
COPY requirements.txt .
RUN pip install --no-cache-dir Flask mysql-connector-python gunicorn flask_sqlalchemy flask-bcrypt PyJWT pymysql cryptography

# ---- Build Stage ----
FROM python:3.9-slim AS builder
WORKDIR /app
COPY . .

# Recreate the non-root user
RUN groupadd -r appuser && useradd --no-log-init -r -g appuser appuser

# Copy installed dependencies before switching users
COPY --from=base /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=base /usr/local/bin /usr/local/bin

# Switch to non-root user after dependencies are installed
USER appuser

# Copy application code
COPY --chown=appuser:appuser . .
COPY --chown=appuser:appuser templates/ templates/

# ---- Final Production Image ----
FROM python:3.9-slim AS final
WORKDIR /app

# Recreate the non-root user
RUN groupadd -r appuser && useradd --no-log-init -r -g appuser appuser

# Switch to non-root user
USER appuser

# Copy the application code securely
COPY --from=builder --chown=appuser:appuser /app /app

# Copy installed dependencies
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Expose port
EXPOSE 5000

# Set entrypoint with secure execution
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--timeout", "120", "--access-logfile", "-", "--error-logfile", "-", "app:app"]