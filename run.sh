#!/bin/bash

#
# This script builds the CloudForest image and starts it in a container. If an image or container with
# the same name as provided already exists, these will be deleted before creating the new image and container.
#
# An existing volume can be passed to the script for data persistence.
#

if [[ $# -lt 2 ]]; then
    echo "Error: tag and container name must be provided.."
    echo "Usage: ./run_it.sh [-v volume_name] [-d] [-s] <tag> <container_name>"
    echo
    echo "The arguments <tag> and <container_name> arguments set the tag and name for"
    echo "the image and container that are created, respectively. Set them however you choose."
    echo "Existing images and containers with the same name will be deleted."
    echo
    echo "-v <volume_name> specifies the name of a pre-existing volume for data persistance."
    echo
    echo "-d can be used to ignore the prompt warning the user that existing containers and images"
    echo "with the same name will be deleted."
    echo
    echo "-s can be used to enable SFTP on 127.0.0.1:8022. Warning: the current implementation of "
    echo "SFTP allows any users to access all SFTP files, so it should only be used in local,"
    echo "single-user contexts."
    exit 1
fi

# Services that should not be included in the image
NONUSE="nodejs,reports,proftp"

PORT_FORWARDING="-p 8080:80"

# If true, don't warn user before deleting image and/or container
DELETE=false

# Don't allow sftp by default because its implementation in galaxy-docker is insecure.
# Should only be used for local instances
ALLOW_SFTP=false

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
	"-s")
	    ALLOW_SFTP=true
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

if [[ $ALLOW_SFTP == "true" ]]; then
    PORT_FORWARDING="$PORT_FORWARDING -p 127.0.0.1:8022:22"
    NONUSE=$(sed 's/,proftp//' <<< $NONUSE)
fi

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

# Build new image, run container, and track logs
docker build -t "$IMAGE_NAME" . &&
docker run -d $PORT_FORWARDING $VOLUME_ARGUMENT --name "$CONTAINER_NAME" -e "NONUSE=$NONUSE" -e "GALAXY_CONFIG_CLEANUP_JOB=onsuccess" -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" -e "GALAXY_SLOTS=4" "$IMAGE_NAME" &&
docker logs -f "$CONTAINER_NAME"
