# Use a stable Python base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

# 1. Install system dependencies safely
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        wget \
        curl \
        git \
        gfortran \
        libblas-dev \
        liblapack-dev \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# 2. Upgrade pip, setuptools, wheel
RUN pip install --upgrade pip setuptools wheel

# 3. Copy requirements
COPY backend/requirements.txt requirements.txt

# 4. Install Python dependencies
# Optional: Install torch separately if it's large
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the backend code
COPY backend/ /app/backend/

# 6. Expose port if using Flask/FastAPI
EXPOSE 5000

# 7. Startup command
CMD ["python", "backend/app.py"]
