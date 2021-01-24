FROM python:3.6.0-alpine
WORKDIR /crawler
ADD requirements.txt /crawler
RUN pip install -r requirements.txt
ADD ./crawler/ /crawler
ENV MONGO mongodb
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE queue
ENV RMQ_USERNAME user
ENV RMQ_PASSWORD PaSsWoRd
ENV CHECK_INTERVAL 30
ENV EXCLUDE_URLS='.*github.com'
ENTRYPOINT ["python", "-u", "crawler.py", "https://vitkhab.github.io/search_engine_test_site/"]