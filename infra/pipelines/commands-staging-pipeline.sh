#!/usr/bin/env bash

# Parameters
AWS_PROFILE=$2
GIT_USERNAME=JJBon
GIT_REPO=mwaa_sandbox
GIT_BRANCH=staging
S3_BUCKET_NAME=jj-dcs-mwaa-staging-pipe
EKSCluster=lh-shared-services
MwaaName=dcs-staging-mwaa
DagsBucketName=jj-dcs-staging-mwaa-dags
EKSNamespace=dcs-staging-mwaa
MWAAVpc=vpc-303f244b
PrivateSub1=subnet-6075ed6f
PrivateSub2=""
PrivateSub3=subnet-81d608af




aws cloudformation $1 --stack-name=dcs-mwaa-staging-pipeline --template-body=file://airflow-staging-pipeline.cfn.yml --profile ${AWS_PROFILE} \
--parameters ParameterKey=GitHubUser,ParameterValue=${GIT_USERNAME} ParameterKey=GitSourceRepo,ParameterValue=${GIT_REPO} \
ParameterKey=GitBranch,ParameterValue=${GIT_BRANCH} ParameterKey=S3Folder,ParameterValue=${S3_BUCKET_NAME} \
ParameterKey=EKSCluster,ParameterValue=${EKSCluster} ParameterKey=MwaaName,ParameterValue=${MwaaName} \
ParameterKey=DagsBucketName,ParameterValue=${DagsBucketName} ParameterKey=EKSNamespace,ParameterValue=${EKSNamespace} \
ParameterKey=MWAAVpc,ParameterValue=${MWAAVpc} ParameterKey=PrivateSub1,ParameterValue=${PrivateSub1} ParameterKey=PrivateSub2,ParameterValue=${PrivateSub2} ParameterKey=PrivateSub3,ParameterValue=${PrivateSub3} --capabilities CAPABILITY_NAMED_IAM 