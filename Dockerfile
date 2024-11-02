# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Use the official PyTorch image as the base
FROM pytorch/pytorch  



# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the .env file (if needed) into the container
COPY .env .env

# Run the bot
CMD ["python", "wtest.py"]
