FROM python:3.10-slim

RUN apt-get update && apt-get install -y gcc default-libmysqlclient-dev

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "manage:app"]