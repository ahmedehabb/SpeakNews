import io
import numpy as np
import tensorflow as tf
from TTS.hparam import hparams
from librosa import effects
from TTS.models import create_model
from TTS.text import text_to_sequence
from TTS.audio import inv_spectrogram_tensorflow,inv_preemphasis,find_endpoint,save_wav
  

class Synthesizer:
  def __init__(self, checkpoint_path, model_name='tacotron'):

    inputs = tf.placeholder(tf.int32, [1, None], 'inputs')
    input_lengths = tf.placeholder(tf.int32, [1], 'input_lengths')
    with tf.variable_scope('model') as scope:
      self.model = create_model(model_name, hparams)
      self.model.initialize(inputs, input_lengths)
      self.wav_output = inv_spectrogram_tensorflow(self.model.linear_outputs[0])


    self.session = tf.Session()
    tf.train.write_graph(self.session.graph_def, '.', 'tacotron.pbtxt')
    
    self.session.run(tf.global_variables_initializer())
    saver = tf.train.Saver()
    saver.restore(self.session, checkpoint_path)


  def synthesize(self, text):
    cleaner_names = [x.strip() for x in hparams.cleaners.split(',')]
    seq = text_to_sequence(text, cleaner_names)
    feed_dict = {
      self.model.inputs: [np.asarray(seq, dtype=np.int32)],
      self.model.input_lengths: np.asarray([len(seq)], dtype=np.int32)
    }
    wav = self.session.run(self.wav_output, feed_dict=feed_dict)
    wav = inv_preemphasis(wav)
    wav = wav[:find_endpoint(wav)]
    out = io.BytesIO()
    save_wav(wav, out)
    return out.getvalue()
