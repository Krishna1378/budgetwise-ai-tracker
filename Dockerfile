# Use a slim, stable Python base image
FROM python:3.10-slim

# 1. Install system dependencies needed for pandas/numpy compilation
# The build-essential package includes the C/C++ compiler
RUN apt-get update && \
    apt-get install -y build-essential python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory for the application
WORKDIR /app

# 2. Copy requirements and install Python dependencies
# This is where pandas will now compile successfully
COPY backend/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# 3. Copy the rest of the backend code
COPY backend/ /app/backend/

# 4. Set the startup command
# Use Gunicorn for production if possible, otherwise use python app.py
# Assuming your app.py is run directly
CMD ["python", "backend/app.py"]
