#!/bin/bash

if [[ $# -ne 2 && $# -ne 3 ]]; then
    echo "Error: incorrect number of arguments."
    echo "Usage: sh run_it.sh <tag> <container_name> [volume_name]"
    echo
    echo "The arguments provide the tag and name for the image and container that are created, respectively."
    echo "Set them however you choose."
    echo
    echo "The third argument is to optionally provide the name of a pre-existing volume for data persistance."
    exit 1
fi

TAG=$1
CONTAINER_NAME=$2

VOLUME_ARGUMENT=""
if [[ $# -eq 3 ]]; then
   VOLUME_ARGUMENT="--mount source=${3},target=/export/"
fi

docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
docker rmi cloudforestphylogenomics/cloudforest_galaxy:$TAG

docker build -t cloudforestphylogenomics/cloudforest_galaxy:$TAG . &&
docker run -d -p 8080:80 $VOLUME_ARGUMENT --name $CONTAINER_NAME -e "NONUSE=nodejs,proftp,reports" -e "GALAXY_CONFIG_CLEANUP_JOB=onsuccess" -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" -e "GALAXY_SLOTS=4" cloudforestphylogenomics/cloudforest_galaxy:$TAG &&
docker logs -f $CONTAINER_NAME
