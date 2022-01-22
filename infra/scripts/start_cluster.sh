#! /usr/bin/env bash

aws ecr-public get-login-password --region us-east-1 --profile $1 | docker login --username AWS --password-stdin public.ecr.aws
cd ../k8s
kind create cluster --name airflow-cluster --config kind-cluster.yaml 
cd ..
kubectl create namespace airflow 
kubectl apply -f ./k8s/airflow-storage-v1.yml -n airflow
kubectl apply -f ./k8s/python-storage.yml -n airflow
kubectl create secret generic coredata-secrets --from-env-file=./environments/.env_dev -n airflow
docker build -t airflow-image:2.0.2 ../airflow-docker 
kind load docker-image airflow-image:2.0.2 --name airflow-cluster
docker build -t python-image:1.0.1 ../python-docker
kind load docker-image python-image:1.0.1 --name airflow-cluster
helm upgrade --install airflow apache-airflow/airflow -n airflow -f ./k8s/values.yaml