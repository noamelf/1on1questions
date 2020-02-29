import json
import random
from pathlib import Path

from flask import Flask, render_template

app = Flask(__name__)

questions_path = Path(__file__).parent / 'questions.json'
with open(questions_path) as f:
    questions = json.load(f)


@app.route('/')
def hello_world():
    question = random.choice(questions)['question']

    return render_template('index.html', name=question)


if __name__ == '__main__':
    app.run()
