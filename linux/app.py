import os
os.system('wget -q https://storage.googleapis.com/vakyansh-open-models/tts/odia/or-IN/female_voice_0/glow.zip && unzip -q glow.zip -d ttsv/checkpoints/female')
os.system('wget -q https://storage.googleapis.com/vakyansh-open-models/tts/odia/or-IN/ma_fe_hifi/hifi.zip && unzip -q hifi.zip -d ttsv/checkpoints/female')
os.system('rm glow.zip && rm hifi.zip')
os.system('wget -q https://storage.googleapis.com/vakyansh-open-models/tts/odia/or-IN/male_voice_1/glow.zip && unzip -q glow.zip -d ttsv/checkpoints/male')
os.system('wget -q https://storage.googleapis.com/vakyansh-open-models/tts/odia/or-IN/ma_fe_hifi/hifi.zip && unzip -q hifi.zip -d ttsv/checkpoints/male')
os.system('wget -q https://storage.googleapis.com/vakyansh-open-models/translit_models.zip -P ttsv/checkpoints/ && unzip -q ttsv/checkpoints/translit_models.zip -d ttsv/checkpoints/')


for path, subdirs, files in os.walk('ttsv/checkpoints/'):
    print(subdirs)
    for name in files:
        print(os.path.join(path, name))

from ttsv.utils.inference.run_gradio import *
from argparse import Namespace

#os.system('python ttsv/utils/inference/run_gradio.py -a ttsv/checkpoints/glow/male -v ttsv/checkpoints/hifi/male -d cpu -L hi')


args = {
    'acoustic':'/home/user/app/ttsv/checkpoints/female/glow,/home/user/app/ttsv/checkpoints/male/glow',
    'vocoder':'/home/user/app/ttsv/checkpoints/female/hifi,/home/user/app/ttsv/checkpoints/male/hifi',
    'device':'cpu',
    'lang':'or'
}

build_gradio(Namespace(**args))