# Getting Started

Welcome to Robot Framework advanced training!

This material assumes you have some basic knowledge of Robot Framework,
Python, and automated acceptance testing.

This training is split into 2 halves: RESTinstance + SeleniumLibrary and Browser.
Both halves use the same exercise files.

Both halves are further divided into 2 parts: REST API and UI.
In the first part (file01), we're going to write tests that use REST API against a mock-up
interface. The exercises in this portion can be done in any order. In the second part (files 02-09),
we're going to make a little deep-dive into web UI testing and learn how to handle several different errors
and how to avoid common pitfalls. _The second portion should be done in order_ as the next
exercise depends on the previous exercise.

All tests are written for the Bad Flask App.
It is a Python [Flask](https://flask.palletsprojects.com/en/1.1.x/) application,
intentionally implemented poorly from a test automation point of view. The UI simulates typical
issues test automation developers face when they write tests for modern websites.

## Prerequisites

You should already have Python 3.x. pip, and Robot Framework 3.2
installed. As of writing this documentation Robot Framework
3.2 is the latest version.

Open also the keyword documentations for

- [BuiltIn](https://robotframework.org/robotframework/latest/libraries/BuiltIn.html)
- [DateTime](https://robotframework.org/robotframework/latest/libraries/DateTime.html)

And either

- [Browser](https://marketsquare.github.io/robotframework-browser/Browser.html)

Or

- [SeleniumLibrary](https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)
- [RESTInstance](https://asyrjasalo.github.io/RESTinstance/)

### Installing Prerequirements

#### SeleniumLibrary

In case you don't have SeleniumLibrary and RESTinstance libraries installed, run the
following commands on the command line in your environment:

- `pip install robotframework-seleniumlibrary`
- `pip install restinstance`

In order to run tests for browsers, you need a driver for that browser in order for Selenium
to gain access to it. Check your browser version and download the correct driver for it from
[here](https://chromedriver.chromium.org/) (for Chrome) or
[here](https://github.com/mozilla/geckodriver/releases) (for Firefox). Other browsers are supported,
but using Chrome or Firefox is recommended.

The driver needs to be placed in your `PATH`. One easy way to do it is to copy the driver you just
downloaded into the same directory where your Python installation is.

- Run `which python3` to show the location of you Python installation.
- Run `cp /path/to/your/chromedriver /path/to/your/bin`.

#### Browser

In case you don't have Browser library installed, see the [official installation instructions](https://github.com/MarketSquare/robotframework-browser#installation-instructions).

### Start Your Server

In all the following cases, the Bad Flask App starts running in `localhost:5000`.
Open your browser to check that you can see the website running correctly.

If you're running on Docker and you can't access `localhost:5000` your Docker machine
is probably not connected to localhost. In this case you need to run `docker inspect <container name>`
to find out the IP address of your container, and connect to port `5000` using that IP address.

#### By using image from Dockerhub

Running the Docker image from Docker Hub. This is the only available
method if you don't want to clone the repository.

`$ docker run -d -p 5000:5000 pleksi/bad-flask-app`

#### By using docker-compose in this repository

`$ docker-compose up -d`

#### By Building the Docker image manually

```bash
$ docker build -t bad-flask-app bad-flask-app
...
$ docker run -d -p 5000:5000 bad-flask-app
```

#### By running the Flask app without using Docker

```bash
$ pip3 install -r bad-flask-app/requirements.txt
...
$ python3 bad-flask-app/app.py
```

In this case you need a new terminal to run your tests.

## Open Exercises Directory

The repo has a directory called `exercises`. All required files are pre-created into the repo
with all necessary tables. Your task is to fill these files during the exercises.

## Running Your Tests

At any time during the training, you can run your tests with `robot -d output tests` (assuming
that you're inside `exercises` directory). You can also add a `-i <tag>` to run only a specific test.

E.g

```bash
robot -d output tests
robot -d output tests/form.robot
robot -d output -i rest tests
robot -d output -i ui tests/form.robot
```
