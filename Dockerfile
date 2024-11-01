# Start from a Python base image (e.g., Python 3.9)
FROM python:3.9-slim

# Install ffmpeg and other necessary system dependencies
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app's code into the container
COPY . .

# Run the application
CMD ["python", "main_bot.py"]
