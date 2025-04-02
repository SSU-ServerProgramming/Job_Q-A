FROM python:3.10-slim

RUN apt-get update && apt-get install -y gcc default-libmysqlclient-dev

WORKDIR /app

COPY ../backend/requirments.txt

RUN pip install -r requirments.txt

COPY ../backend .


CMD ["flask", "run", "--host=0.0.0.0"]