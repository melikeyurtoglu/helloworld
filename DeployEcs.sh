#!/bin/bash
SERVICE_NAME="helloworldservice"
IMAGE_VERSION="v_"${BUILD_NUMBER}
TASK_FAMILY="helloworld"

# Create a new task definition for this build
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" helloworld.json > helloworld-v_${BUILD_NUMBER}.json
aws ecs register-task-definition --family helloworld --cli-input-json file://helloworld-v_${BUILD_NUMBER}.json

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --task-definition helloworld --output=json| egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
aws ecs update-service --cluster default --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION//,} --desired-count 1
