import re
# import nltk
import string
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from nltk.corpus import stopwords
from nltk.stem import SnowballStemmer, WordNetLemmatizer
from sklearn.feature_extraction.text import TfidfVectorizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from waitress import serve
from flask import Flask,send_file
from flask import request
import keras 
import pickle

sns.set(font_scale=1.3)
# nltk.download('omw-1.4') 
def lemmatization(text):
    lemmatizer= WordNetLemmatizer()
    text = text.split()
    text=[lemmatizer.lemmatize(y) for y in text]

    return " " .join(text)
def remove_stop_words(text):
    stop_words = set(stopwords.words("english"))
    Text=[i for i in str(text).split() if i not in stop_words]
    return " ".join(Text)
def Removing_numbers(text):
    text=''.join([i for i in text if not i.isdigit()])
    return text
def lower_case(text):
    
    text = text.split()
    text=[y.lower() for y in text]
    
    return " " .join(text)
def Removing_punctuations(text):
    ## Remove punctuations
    text = re.sub('[%s]' % re.escape("""!"#$%&'()*+,،-./:;<=>؟?@[\]^_`{|}~"""), ' ', text)
    text = text.replace('؛',"", )
    
    ## remove extra whitespace
    text = re.sub('\s+', ' ', text)
    text =  " ".join(text.split())
    return text.strip()
def Removing_urls(text):
    url_pattern = re.compile(r'https?://\S+|www\.\S+')
    return url_pattern.sub(r'', text)
def remove_small_sentences(df):
    for i in range(len(df)):
        if len(df.text.iloc[i].split()) < 3:
            df.text.iloc[i] = np.nan
            
def normalize_text(df):
    df.Text=df.Text.apply(lambda text : lower_case(text))
    df.Text=df.Text.apply(lambda text : remove_stop_words(text))
    df.Text=df.Text.apply(lambda text : Removing_numbers(text))
    df.Text=df.Text.apply(lambda text : Removing_punctuations(text))
    df.Text=df.Text.apply(lambda text : Removing_urls(text))
    df.Text=df.Text.apply(lambda text : lemmatization(text))
    return df
def normalized_sentence(sentence):
    sentence= lower_case(sentence)
    sentence= remove_stop_words(sentence)
    sentence= Removing_numbers(sentence)
    sentence= Removing_punctuations(sentence)
    sentence= Removing_urls(sentence)
    sentence= lemmatization(sentence)
    return sentence
class SentimentAnalysis:
    def __init__(self) -> None:
        self.model=keras.models.load_model('Emotion Recognition From English text.h5')
        with open('tokenizer.txt', 'rb') as f:
            self.tokenizer = pickle.load(f)
        with open('label.txt', 'rb') as f:
            self.le = pickle.load(f)
    def predict(self,text):
        sentence = normalized_sentence(text)
        sentence = self.tokenizer.texts_to_sequences([sentence])
        sentence = pad_sequences(sentence, maxlen=229, truncating='pre')
        result = self.le.inverse_transform(np.argmax(self.model.predict(sentence), axis=-1))[0]
        proba =  np.max(self.model.predict(sentence))
        print(f"{result} : {proba}\n\n")
        return result,proba

sentiment_analysis = SentimentAnalysis()

app = Flask(__name__)
@app.route('/sentiment',methods=["POST"])
def hello():
    args = request.json
    output = sentiment_analysis.predict(args['text'])
    return {"prediction": str(output[0]),"probability": output[1].astype(float)}
def run():
    serve(app, host="0.0.0.0", port=6000)
    return app
if __name__ == '__main__':
    app.run(host="0.0.0.0", port=2000, debug=True)          

           



