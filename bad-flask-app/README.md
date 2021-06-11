# Bad Flask App

A Flask application intentionally designed to be poor in a test automation point-of-view.

All changes to the app should be built with Docker and pushed to `pleksi/bad-flask-app`.

## Running

Run with

1. `docker build -t bad-flask-app .`
2. `docker run -p 5000:5000 bad-flask-app`

or

1. `docker run -p 5000:5000 pleksi/bad-flask-app`

or

1. `pip install -r requirements.txt`
2. `python app.py`
