from datetime import datetime

from kubernetes.client import models as k8s

from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
from airflow.kubernetes.secret import Secret
from datetime import datetime, timedelta
import os 

airflow_home = os.environ.get("AIRFLOW_HOME")

secret_env = Secret('env', None, 'dcs-secrets')

volume_mount = k8s.V1VolumeMount(
    name='python-pv', mount_path='/python_code', sub_path=None, read_only=True
)

volume = k8s.V1Volume(
    name='python-pv',
    persistent_volume_claim=k8s.V1PersistentVolumeClaimVolumeSource(claim_name='python-pvc')
)

local_args = {
    "image":"python-image:1.0.1",
    "secrets":[secret_env],
    "volumes": [volume],
    "volume_mounts": [volume_mount],
    "in_cluster": True,
    "namespace": "airflow",
    "is_delete_operator_pod":False
}

aws_args = {
    "image":"668102661106.dkr.ecr.us-east-1.amazonaws.com/mwaa_sandbox-staging",
    "in_cluster": False,
    "cluster_context":"aws",
    "image_pull_policy":"Always",
    "secrets":[secret_env],
    "config_file":f"{airflow_home}/dags/kube_config.yaml",
    "namespace":"dcs-staging-mwaa",
    "is_delete_operator_pod": True
}
