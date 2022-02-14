ARG pc_environ

#FROM python:3.6.9-slim-stretch
FROM public.ecr.aws/e2e1t5k9/python-docker as aws-env
ENV PYTHONPATH='/python_code'
#FROM python:3.7.10-slim-stretch
#RUN apt update && apt-get install python3-dev -y && apt-get install libevent-dev -y
RUN apt update && apt install build-essential -y && apt-get install manpages-dev -y
RUN pip install --upgrade pip
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN pip3 install pytest
COPY python_code /python_code

FROM aws-env as local-env
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_SESSION_TOKEN
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
ENV AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
ENV AWS_DEFAULT_REGION=us-east-1
ENV AWS_REGION=us-east-1

RUN echo ${pc_environ}
FROM ${pc_environ}-env as final 