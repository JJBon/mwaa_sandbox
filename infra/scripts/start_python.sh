#! /usr/bin/env bash

set -a
aws-vault exec $1 -- docker-compose -f ../../python-docker/docker-compose-dev.debug.yml up  --build -d 
