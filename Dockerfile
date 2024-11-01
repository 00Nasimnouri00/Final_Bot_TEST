FROM python:3.9-slim-buster

# Install dependencies including git and ffmpeg
RUN apt-get update && \
    apt-get install -y ffmpeg git

# Install Python dependencies: FFMPEG-Python, PyTorch, and Whisper
RUN pip install --upgrade ffmpeg-python torch==1.10.1 torchvision torchaudio -f https://download.pytorch.org/whl/cu111/torch_stable.html tqdm tiktoken numba

# Install Whisper from GitHub
RUN pip install --upgrade --no-deps --force-reinstall git+https://github.com/openai/whisper.git

# Set the working directory
WORKDIR /app

# Copy requirements.txt to the working directory
COPY requirements.txt .

# Install Python dependencies from requirements.txt
RUN pip install --upgrade -r requirements.txt

# Copy bot code to the container (assuming you have main_bot.py or similar)
COPY . .

# Run the bot script
CMD ["python", "main_bot.py"]
