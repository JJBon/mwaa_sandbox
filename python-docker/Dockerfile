#FROM python:3.6.9-slim-stretch
FROM public.ecr.aws/e2e1t5k9/python-docker
ENV PYTHONPATH='/python_code'
#FROM python:3.7.10-slim-stretch
#RUN apt update && apt-get install python3-dev -y && apt-get install libevent-dev -y
RUN apt update && apt install build-essential -y && apt-get install manpages-dev -y
RUN pip install --upgrade pip
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY python_code /python_code
