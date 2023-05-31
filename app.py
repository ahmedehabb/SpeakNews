from flask import Flask
from flask import request
from TTS.synthesizer import Synthesizer
# import requests
import os
import json


app = Flask(__name__)


tts_object = Synthesizer(os.path.join(os.path.dirname(__file__),"TTS","model.ckpt"))

@app.route('/text_to_speech',methods=["POST"])
def hello():
    # print("Hi")
    args = request.json
    # print("Args ", args)
    text = args["text"]
    # print(text)
    
    output_sound = tts_object.synthesize(text)
    return output_sound

if __name__ == '__main__':
    app.run()
