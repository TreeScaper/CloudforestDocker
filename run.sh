#!/bin/bash

#
# This script builds the CloudForest image and starts it in a container. If an image or container with
# the same name as provided already exists, these will be deleted before creating the new image and container.
#
# An existing volume can be passed to the script for data persistence.
#

if [[ $# -lt 2 ]]; then
    echo "Error: tag and container name must be provided.."
    echo "Usage: ./run_it.sh [-v volume_name] [-d] <tag> <container_name>"
    echo
    echo "The arguments <tag> and <container_name> arguments set the tag and name for"
    echo "the image and container that are created, respectively. Set them however you choose."
    echo "Existing images and containers with the same name will be deleted."
    echo
    echo "-v <volume_name> specifies the name of a pre-existing volume for data persistance."
    echo
    echo "-d can be used to ignore the prompt warning the user that existing containers and images"
    echo "with the same name will be deleted."
    exit 1
fi

# If true, don't warn user before deleting image and/or container
DELETE=false

# Optional arguments before the required tag and container name
while [[ $# -gt 2 ]]; do
    case $1 in
	"-v")
	    shift
	    VOLUME_ARGUMENT="--mount source=${1},target=/export/"
	    shift
	    ;;
	"-d")
	    DELETE=true
	    shift
	    ;;
	*)
	    echo "Error: unrecognized option: $1"
	    exit 1
	    ;;
    esac
done

TAG=$1
shift

CONTAINER_NAME=$1
shift

IMAGE_NAME="cloudforestphylogenomics/cloudforest_galaxy:$TAG"

# Check if container already exists
container_exists=false
docker container ls | grep "$CONTAINER_NAME" >/dev/null
if [[ $? -eq 0 ]]; then
    container_exists=true
fi

# Check if image already exists
image_exists=false
existing_id=$(docker images -q "$IMAGE_NAME")
if [[ ! -z $existing_id ]]; then
    image_exists=true
fi

# Warn user about deletion of image & container
if [[ $DELETE == false && ($image_exists == true || $container_exists == true) ]]; then
    echo
    echo "This script will stop and delete container $CONTAINER_NAME, and delete image $IMAGE_NAME if they already exist."
    read -p "Press enter to continue, or Ctrl-C to abort..."
fi

# Stop container if running.
docker ps -a | grep "$CONTAINER_NAME" >/dev/null
if [[ $? -eq 0 ]]; then
    echo -n "Stopping container: "
    docker stop "$CONTAINER_NAME"
fi

# Remove container if it exists
if [[ $container_exists == true ]]; then
    echo -n "Removing container: "
    docker rm "$CONTAINER_NAME"
fi

# Remove image if it exists
if [[ $image_exists == true ]]; then
    docker rmi "$IMAGE_NAME"
fi

echo VOLUME_ARGUMENT $VOLUME_ARGUMENT
# Build new image, run container, and track logs
docker build -t "$IMAGE_NAME" . &&
docker run -d -p 8080:80 $VOLUME_ARGUMENT --name "$CONTAINER_NAME" -e "NONUSE=nodejs,proftp,reports" -e "GALAXY_CONFIG_CLEANUP_JOB=onsuccess" -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" -e "GALAXY_SLOTS=4" "$IMAGE_NAME" &&
docker logs -f "$CONTAINER_NAME"
