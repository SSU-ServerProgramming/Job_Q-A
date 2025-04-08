FROM python:3.10-slim

RUN apt-get update && apt-get install -y gcc default-libmysqlclient-dev

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

CMD ["flask", "run", "--host=0.0.0.0"]