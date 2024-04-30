# Use a base Python image
#FROM python:3.8

#ENV PYTHONUNBUFFERED 1

#WORKDIR /app/myproject
#COPY requirements.txt ./
#RUN pip install -r requirements.txt
#COPY . ./
#EXPOSE 8000	
# Use a smaller base image
# Use a smaller base image
FROM python:3.8-slim

ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \   
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/myproject

# Copy and install requirements first to leverage Docker cache
COPY requirements.txt ./

# Install build dependencies for MySQL client
RUN apt-get update && apt-get install -y \
    libmariadb-dev-compat \
    libmariadb-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages from requirements.txt
RUN pip install -r requirements.txt

# Copy the rest of the application
COPY . ./
CMD ["sh", "-c", "python manage.py makemigrations && python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]

# Expose port (optional)
EXPOSE 8000


