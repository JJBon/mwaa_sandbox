#!/usr/bin/env bash

# Parameters
AWS_PROFILE=default
GIT_USERNAME=la-haus
GIT_REPO=data-mwaa
GIT_BRANCH=prod
S3_BUCKET_NAME=coredata-mwaa-prod-pipeline
EKSCluster=lh-production
MwaaName=coredata-prod-mwaa
DagsBucketName=coredata-prod-mwaa-dags
EKSNamespace=coredata-prod-mwaa
MWAAVpc=vpc-0aa3e26571585ff85
PrivateSub1=subnet-0d4b75228e1737875
PrivateSub2=subnet-0a2c5e7f474deb6a7
PrivateSub3=subnet-03bc43fb3403f2b2b





aws cloudformation $1 --stack-name=coredata-mwaa-prod-pipeline --template-body=file://airflow-prod-pipeline.cfn.yml --profile $2 \
--parameters ParameterKey=GitHubUser,ParameterValue=${GIT_USERNAME} ParameterKey=GitSourceRepo,ParameterValue=${GIT_REPO} \
ParameterKey=GitBranch,ParameterValue=${GIT_BRANCH} ParameterKey=S3Folder,ParameterValue=${S3_BUCKET_NAME} \
ParameterKey=EKSCluster,ParameterValue=${EKSCluster} ParameterKey=MwaaName,ParameterValue=${MwaaName} \
ParameterKey=DagsBucketName,ParameterValue=${DagsBucketName} ParameterKey=EKSNamespace,ParameterValue=${EKSNamespace} \
ParameterKey=MWAAVpc,ParameterValue=${MWAAVpc} ParameterKey=PrivateSub1,ParameterValue=${PrivateSub1} ParameterKey=PrivateSub2,ParameterValue=${PrivateSub2} ParameterKey=PrivateSub3,ParameterValue=${PrivateSub3} --capabilities CAPABILITY_NAMED_IAM 