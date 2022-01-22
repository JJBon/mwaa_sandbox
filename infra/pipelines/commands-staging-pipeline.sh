#!/usr/bin/env bash

# Parameters
AWS_PROFILE=$2
GIT_USERNAME=la-haus
GIT_REPO=dcs-mwaa
GIT_BRANCH=staging
S3_BUCKET_NAME=jj-dcs-mwaa-staging-pipe
EKSCluster=lh-shared-services
MwaaName=dcs-staging-mwaa
DagsBucketName=jj-dcs-staging-mwaa-dags
EKSNamespace=dcs-staging-mwaa
MWAAVpc=vpc-0e6eb452255a05512
PrivateSub1=subnet-01eda08c882f8f84f
PrivateSub2=""
PrivateSub3=subnet-0b5b637bb2fd70cb7




aws cloudformation $1 --stack-name=dcs-mwaa-staging-pipeline --template-body=file://airflow-staging-pipeline.cfn.yml --profile ${AWS_PROFILE} \
--parameters ParameterKey=GitHubUser,ParameterValue=${GIT_USERNAME} ParameterKey=GitSourceRepo,ParameterValue=${GIT_REPO} \
ParameterKey=GitBranch,ParameterValue=${GIT_BRANCH} ParameterKey=S3Folder,ParameterValue=${S3_BUCKET_NAME} \
ParameterKey=EKSCluster,ParameterValue=${EKSCluster} ParameterKey=MwaaName,ParameterValue=${MwaaName} \
ParameterKey=DagsBucketName,ParameterValue=${DagsBucketName} ParameterKey=EKSNamespace,ParameterValue=${EKSNamespace} \
ParameterKey=MWAAVpc,ParameterValue=${MWAAVpc} ParameterKey=PrivateSub1,ParameterValue=${PrivateSub1} ParameterKey=PrivateSub2,ParameterValue=${PrivateSub2} ParameterKey=PrivateSub3,ParameterValue=${PrivateSub3} --capabilities CAPABILITY_NAMED_IAM 