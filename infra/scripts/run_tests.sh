#! /usr/bin/env bash

# get airflow scheduler pod
podName=$(kubectl get pod -o=json -n airflow | jq -r '.items[] | select(.metadata.labels.component=="scheduler") | .metadata.name')
# execute airflow integration tests from pod
kubectl exec -i -t $podName -n airflow --container scheduler -- pytest unittests