FROM python:3.10-alpine

ARG PORT
ENV PORT=$PORT

RUN pip install --upgrade pip
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt
COPY . /app

ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
