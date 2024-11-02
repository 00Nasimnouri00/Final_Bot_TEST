#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import ffmpeg
import whisper
import librosa
import librosa.display
import numpy as np
import matplotlib.pyplot as plt
import os
from telebot import TeleBot
from dotenv import load_dotenv
from pydub import AudioSegment
from dotenv import load_dotenv


# In[ ]:


# Load environment variables from the .env file
load_dotenv()

bot = TeleBot(os.environ.get("TELEGRAM_BOT_TOKEN"))

@bot.message_handler(commands=["start"])
def send_welcome(message):
    bot.reply_to(message, "Welcome! Send me an audio file recorded in Telegram.")

@bot.message_handler(content_types=['audio', 'voice'])
def handle_audio(message):
    try:
        # Notify user that the voice message was received
        bot.reply_to(message, "We received your voice message.")

        # Get the file ID of the audio message
        file_id = message.audio.file_id if message.content_type == 'audio' else message.voice.file_id
        file_info = bot.get_file(file_id)
        downloaded_file = bot.download_file(file_info.file_path)

        # Save the OGG file temporarily
        ogg_path = "user_audio.ogg"
        with open(ogg_path, 'wb') as new_file:
            new_file.write(downloaded_file)

        # Notify user that the conversion is in progress
        bot.reply_to(message, "Converting audio to .wav format...")

        # Convert OGG to WAV
        wav_path = "user_audio.wav"
        audio = AudioSegment.from_ogg(ogg_path)
        audio.export(wav_path, format="wav")
        os.remove(ogg_path)  # Clean up the OGG file

        # Notify user that transcription is in progress
        bot.reply_to(message, "Transcribing audio...")

        # Transcribe audio using Whisper model
        base_model = whisper.load_model("base")
        result = base_model.transcribe(wav_path)
        transcription = result["text"]

        # Send transcription text to the user
        bot.reply_to(message, f"Transcription:\n{transcription}")

        # Clean up the WAV file
        os.remove(wav_path)

    except Exception as e:
        bot.reply_to(message, f"An error occurred: {str(e)}")

#######################################################
if __name__ == "__main__":
    bot.polling()

