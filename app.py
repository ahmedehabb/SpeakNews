from flask import Flask,send_file
from flask import request
from TTS.synthesizer import Synthesizer
from TTS.audio import save_wav
# import requests
import os
import io
from pydub import AudioSegment


app = Flask(__name__)



import numpy as np


# Define the input text
text = "A keen historian, he wrote a number of books and fronted TV documentaries on ancient and medieval history. This Terry Jones had a love of the absurd that contributed much to the anarchic humour of Monty Python's Flying Circus. An Iranian chess referee says she is frightened to return home after she was criticized online for not wearing the appropriate headscarf during an international tournament. Currently the chief adjudicator at the Women's World Chess Championship held in Russia and China, Shohreh Bayat says she fears arrest after a photograph of her was taken during the event and was then circulated online in Iran."

# Split the text into 16 words per split
# words = text.split()
# split_texts = [words[i:i+16] for i in range(0, len(words), 16)]
# # while the last word is less than 4 letters in each split then add it to the next split
# for i in range(len(split_texts)):
#     while len(split_texts[i][-1]) < 4:
#         split_texts[i].append(split_texts[i+1].pop(0))
# print(split_texts)
# # Collect the audio outputs from each split
# audio_outputs = []
# for split_text in split_texts:
#     split_text = " ".join(split_text)

#     # Process the split text


# # Concatenate the audio outputs from each split
# concatenated_audio = np.concatenate(audio_outputs)

# # Play the concatenated audio
# ipd.Audio(concatenated_audio, rate=hparams.sampling_rate)


tts_object = Synthesizer(os.path.join(os.path.dirname(__file__),"TTS","model.ckpt"))

@app.route('/text_to_speech',methods=["POST"])
def hello():
    # print("Hi")
    args = request.json
    # print("Args ", args)
    text = args["text"]
    # print(text)
    words = text.split()
    split_texts = [words[i:i+10] for i in range(0, len(words), 10)]
    print(split_texts)
    
    # while the last word is less than 4 letters in each split then add it to the next split
    for i in range(len(split_texts) -1):
        while len(split_texts[i-1][-1]) < 4:
            split_texts[i-1].append(split_texts[i].pop(0))
    
    audio_outputs = []
    for split_text in split_texts:
        split_text = " ".join(split_text)
        output_sound = tts_object.synthesize(split_text)
        # wav_file_bytes = io.BytesIO(output_sound)
        # # save_wav(output_sound,os.path.join(os.path.dirname(__file__),"output.wav"))
        # return send_file(wav_file_bytes, mimetype='audio/wav')
        # print(type(output_sound))
        audio_outputs.append(output_sound)


    combined_audio = AudioSegment.empty()

    for audio_segment in audio_outputs:
        combined_audio += AudioSegment.from_file(io.BytesIO(audio_segment))

    # Export the combined audio to bytes
    audio_data = io.BytesIO()
    combined_audio.export(audio_data, format='wav')
    audio_data.seek(0)

    return send_file(audio_data, mimetype='audio/wav')
    audio_data = b"".join(audio_outputs)
    
    wav_file_bytes = io.BytesIO(audio_data)
    # save_wav(output_sound,os.path.join(os.path.dirname(__file__),"output.wav"))
    return send_file(wav_file_bytes, mimetype='audio/wav')

from waitress import serve
def run():
    # app = create_application()
    # make_celery(app)
    # register_routes(app)

    
    serve(app, host="0.0.0.0", port=5000)
    return app


if __name__ == '__main__':
    run()
