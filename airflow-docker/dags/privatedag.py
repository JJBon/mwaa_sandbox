"""
Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"""
from datetime import datetime

from kubernetes.client import models as k8s

from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
from airflow.operators.bash_operator import BashOperator
from airflow.kubernetes.secret import Secret
from datetime import datetime, timedelta
import os

if os.environ.get('LOCAL'):
    from utils.k8s_params import local_args
    podArgs = local_args
else:
    from utils.k8s_params import aws_args
    podArgs = aws_args


default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email": ["support@airflow.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5)
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2021, 1, 1),
}


with DAG(
    dag_id='example_kubernetes_operator',
    schedule_interval=None,
    start_date=datetime(2021, 1, 1),
    tags=['example'],
    default_args=default_args
) as dag:

    # image, secrets, volumes, volume_mounts,in_cluster
    # t1 = BashOperator(
    # task_id='gen_context_file',
    # bash_command='aws eks update-kubeconfig --region us-east-1 --kubeconfig /usr/local/airflow/.kube/config --name lh-staging --alias aws'
    # )

    podRun = KubernetesPodOperator(
                        cmds=["bash"],
                        #arguments=["-c", "python -m /opt/airflow/python_code/test_code.py"],
                        arguments=["-c", "python /python_code/test_code.py"],
                        labels={"task": "pod_run","pod_name":"podRun2"},
                        name="mwaa-tests",
                        task_id="podRun",
                        get_logs=True,
                        dag=dag,
                        service_account_name="mwaa-service-account",
                        **podArgs
                        )

    #t1 >> podRun

    