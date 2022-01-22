#!/usr/bin/env bash

# Parameters
AWS_PROFILE=$2
GIT_USERNAME=la-haus
GIT_REPO=dcs-mwaa
GIT_BRANCH=dev
S3_BUCKET_NAME=jj-dcs-mwaa-dev-pipe

aws cloudformation $1 --stack-name=dcs-mwaa-dev-pipeline --template-body=file://airflow-dev-pipeline.cfn.yml --profile ${AWS_PROFILE} \
--parameters ParameterKey=GitHubUser,ParameterValue=${GIT_USERNAME} ParameterKey=GitSourceRepo,ParameterValue=${GIT_REPO} \
ParameterKey=GitBranch,ParameterValue=${GIT_BRANCH} ParameterKey=S3Folder,ParameterValue=${S3_BUCKET_NAME} ParameterKey=GitCryptKey,ParameterValue=${GIT_CRYPT_KEY} \
--capabilities CAPABILITY_NAMED_IAM 