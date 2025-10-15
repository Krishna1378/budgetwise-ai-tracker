# Use a stable, slim Python base image
FROM python:3.10-slim

# Set environment variables to prevent buffering issues
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

# 1. Install system dependencies for compiling packages like pandas/numpy
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        wget \
        curl \
        git \
        libatlas-base-dev \
        gfortran \
        libblas-dev \
        liblapack-dev \
        && rm -rf /var/lib/apt/lists/*

# Set the working directory for the application
WORKDIR /app

# 2. Upgrade pip, setuptools, and wheel first
RUN pip install --upgrade pip setuptools wheel

# 3. Copy requirements file and install Python dependencies
COPY backend/requirements.txt requirements.txt

# Separate installation for large packages like torch to avoid BrokenPipeError
# Install torch CPU-only wheel (smaller, faster)
RUN pip install --upgrade torch --index-url https://download.pytorch.org/whl/cpu

# Now install the rest of the requirements
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copy the rest of the backend code
COPY backend/ /app/backend/

# 5. Expose the port (if using Flask/FastAPI)
EXPOSE 5000

# 6. Set the startup command
# For production, you can replace this with Gunicorn: ["gunicorn", "backend.app:app"]
CMD ["python", "backend/app.py"]
