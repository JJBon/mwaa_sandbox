FROM public.ecr.aws/e2e1t5k9/airflow-docker
COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt
COPY dags/ ${AIRFLOW_HOME}/dags
COPY unittests/ ${AIRFLOW_HOME}/unittests
RUN pip3 install pytest
CMD ["python"]