FROM python:3.6-alpine3.7

RUN apk update
RUN apk add supervisor
RUN apk add --update py2-pip
RUN pip install gunicorn

# reqs layer
ADD requirements.txt .
RUN pip3 install -U -r requirements.txt

# Bundle app source
ADD . /src

# Expose
EXPOSE  5000

COPY ./deployment/logging.conf /src/logging.conf
COPY ./deployment/gunicorn.conf /src/gunicorn.conf

WORKDIR /src

# Start processes
CMD ["/usr/local/bin/gunicorn", "application:application", "-w", "4", "--config", "/src/gunicorn.conf", "--log-config", "/src/logging.conf", "--bind", "0.0.0.0:5000"]
