FROM python:3.8-slim

WORKDIR /flask

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD ["python", "app.py"]
