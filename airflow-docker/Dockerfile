#FROM apache/airflow:2.0.2-python3.7
#FROM public.ecr.aws/bitnami/airflow:2.0.2-debian-10-r18
FROM public.ecr.aws/e2e1t5k9/airflow-docker
COPY dags/ ${AIRFLOW_HOME}/dags
COPY unittests/ ${AIRFLOW_HOME}/unittests
COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt
CMD ["python"]