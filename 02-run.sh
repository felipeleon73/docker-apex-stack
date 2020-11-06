#!/bin/bash

CONTAINER_NAME=${1:-axer}
ENV_FILE=${2:-.env}

. $ENV_FILE

BASE_DIR=$(pwd -P)
DB_VERSION=${DB_VERSION:-18.4.0}
DB_EDITION=$(echo ${DB_EDITION:-xe} | tr '[:upper:]' '[:lower:]')
HOST_DATA_DIR=${CONTAINER_NAME}-oradata
DOCKER_NETWORK_NAME=${DOCKER_NETWORK_NAME:-bridge}
FILES_DIR=${FILES_DIR:-$BASE_DIR/files}

echo "##### Check if Docker network $DOCKER_NETWORK_NAME #####"
docker network inspect -f {{.Name}} $DOCKER_NETWORK_NAME || \
  echo "##### Create Docker network $DOCKER_NETWORK_NAME #####"; \
  docker network create $DOCKER_NETWORK_NAME

echo "##### Removing any previous containers #####"
docker rm -vf $CONTAINER_NAME

echo "##### Creating container $CONTAINER_NAME #####"
  docker run -d --name $CONTAINER_NAME \
          --network ${DOCKER_NETWORK_NAME} \
          -p ${DOCKER_ORDS_PORT:-50080}:8080 \
          -p ${DOCKER_EM_PORT:-55500}:5500 \
          -p ${DOCKER_DB_PORT:-51521}:1521 \
          -v oracle-data:/opt/oracle/oradata \
          --env-file $ENV_FILE \
          --tmpfs /dev/shm:rw,exec,size=2G \
          oracle/database:${DB_VERSION}-${DB_EDITION}

echo "##### Tailing logs. Ctrl-C to exit. #####"
docker logs -f $CONTAINER_NAME
