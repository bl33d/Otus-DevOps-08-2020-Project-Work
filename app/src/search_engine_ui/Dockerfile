FROM python:3.6.0-alpine
WORKDIR /ui
ADD requirements.txt /ui
RUN pip install -r requirements.txt
ADD ./ui/ /ui
EXPOSE  8000
ENV MONGO mongodb
ENV MONGO_PORT 27017
ENV FLASK_APP ui.py
ENTRYPOINT ["gunicorn", "ui:app", "-b", "0.0.0.0"]