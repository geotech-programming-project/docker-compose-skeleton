FROM python:3.8-slim

COPY . .

WORKDIR /flask

RUN pip install -r requirements.txt

CMD ["python", "app.py"]
