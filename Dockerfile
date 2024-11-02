FROM python:3.9-slim-buster

# Install system dependencies including git and ffmpeg
RUN apt-get update && \
    apt-get install -y ffmpeg git

# Set the working directory
WORKDIR /app

# Copy requirements.txt to the working directory
COPY requirements.txt .

# Install Python dependencies from requirements.txt
RUN pip install --upgrade -r requirements.txt

# Copy the rest of the bot code to the working directory
COPY . .

# Run the bot script
CMD ["python", "wtest.py"]
