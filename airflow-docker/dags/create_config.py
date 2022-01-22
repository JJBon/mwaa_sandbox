from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
#from utils.context_generator import gen_context_file

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": datetime(2020, 1, 1),
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

def parsing():
    return True

def processing():
    return True

with DAG("create_config", default_args=default_args, schedule_interval=None, catchup=False) as dag:
    #t1 = PythonOperator(task_id="gen_context_file", python_callable=gen_context_file)
    t1 = BashOperator(
    task_id='gen_context_file',
    bash_command='aws eks update-kubeconfig --region us-east-1 --kubeconfig ./kube_config.yaml --name lh-shared-services --alias aws'
    )
  
    
