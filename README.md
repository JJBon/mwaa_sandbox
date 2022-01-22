# Deploy with cloud formation script

## ENV vars:
Make sure to export GIT_TOKEN env var for pipeline to deploy

## Parameters:

Please define paramters on sh file infra/deploy/commands-staging-pipeline.sh and ensure all resources except the eks cluster does not exist.

**AWS_PROFILE**: Change parameter to use relevant account profile

Terraform vars:
- **EKSCluster**: Name of existing terraform cluster that terraform  will connect to.
- **MwaaName**: Name of mwaa environment
- **DagsBucketName**: S3 folder where mwaa dags will be stored
- **EKSNamespace**: Namespace to be created on eks exlusively for mwaa resources

Repository vars:
- **GIT_USERNAME**: Git repo associated user
- **GIT_REPO**: Git repo codebuild will use for CI/CD
- **GIT_BRANCH**: Git branch to be used by codepipeline 
CodeBuild/PipelineVars
- **S3_BUCKET_NAME**: Bucket name to be used for storing CI/CD artifacts



```console
#!/usr/bin/env bash

# Parameters
AWS_PROFILE=default
GIT_USERNAME=la-haus
GIT_REPO=dcs-mwaa
GIT_BRANCH=staging
S3_BUCKET_NAME=dcs-mwaa-staging-pipeline
EKSCluster=lh-staging
MwaaName=dcs-staging-mwaa
DagsBucketName=dcs-staging-mwaa-dags
EKSNamespace=dcs-staging-mwaa
MWAAVpc=vpc-0416d31a5f63947f9
PrivateSub1=subnet-04ac18a4422f45b1e
PrivateSub2=subnet-0895bca0d04197952
PrivateSub3=subnet-040dabe070271875b


aws cloudformation create-stack --stack-name=dcs-mwaa-staging-pipeline --template-body=file://airflow-staging-pipeline.cfn.yml --profile ${AWS_PROFILE} \
--parameters ParameterKey=GitHubUser,ParameterValue=${GIT_USERNAME} ParameterKey=GitSourceRepo,ParameterValue=${GIT_REPO} \
ParameterKey=GitBranch,ParameterValue=${GIT_BRANCH} ParameterKey=S3Folder,ParameterValue=${S3_BUCKET_NAME} \
ParameterKey=EKSCluster,ParameterValue=${EKSCluster} ParameterKey=MwaaName,ParameterValue=${MwaaName} \
ParameterKey=DagsBucketName,ParameterValue=${DagsBucketName} ParameterKey=EKSNamespace,ParameterValue=${EKSNamespace} \
ParameterKey=MWAAVpc,ParameterValue=${MWAAVpc} ParameterKey=PrivateSub1,ParameterValue=${PrivateSub1} ParameterKey=PrivateSub2,ParameterValue=${PrivateSub2} ParameterKey=PrivateSub3,ParameterValue=${PrivateSub3} --capabilities CAPABILITY_NAMED_IAM 
```

# Execute local environment

Navigate to infra/scripts to have access to different files that allow to start and stop local environment. Currently there are two environments one consists of a docker-compose setup and handles python, the second one consists on airflow running on a local kubernetes cluster. Although these environments are separated, the code that is edited on the python environment will be updated on the airflow environment. This means that tasks can be either executed in isolation with only the python environment active or they can be triggered through the airflow environment.  

## Python Environment:

In order to execute the python environment two scripts can be executed. For starting the environment use infra/scripts/start_python.sh and for deleting use infra/scripts/end_python.sh. The environment is executed using a docker-compose file that builds an image from python-docker/Dockerfile . The docker file will use the requirements.txt located on the same directory to install all python dependencies required for script excecution. The python_docker/python_code folder is used as a volume, meaning everything edited on that folder will be available in the container.



```console
version: '3.4'
services:
  python_services:
    image: python_services:1.0.1
    stdin_open: true
    tty: true 
    volumes:
        - ./python_code:/python_code
    build:
      context: .
      dockerfile: ./Dockerfile
    entrypoint: /bin/sh
    ports:
      - 8000:8000
      - 5678:5678
```

## Airflow Environment:

### Required Programs to launch Airflow:

- Docker: Required to launch containers and build images.
- Kind: Program that allows to lunch kuberenetes in docker using containers as nodes
- Kubectl: Kubernetes client 
- Git-Crypt: Allows to encrypt and decrypt files on repo 
- Helm: Used to download and install apps on a kubernetes cluster
  - After installing helm, download the airflow release helm repo add apache-airflow https://airflow.apache.org

### Starting k8s local cluster

Once required programs are installed proceed to excecuting infra/scripts/start_cluster.sh. The script will launch a kind k8s cluster. Over that cluster airflow will be installed using helm and the airflow and python repo images will be used in conjunction to execute dags. Dags can be edited on airflow-docker/dags, and python code launched by the kubernetes pod operator can be edited on python-docker/python_code. 

