#!/bin/bash

#
# This script starts and stops the CloudForest instance. It manages user options and
# runs the necessary docker-compose configuration.
#

print_help () {
    cat << EOF
Usage: ./run_it.sh [--tag tag_name] [--sftp] [--follow]

--tag <tag_name>
Run an image from the cloudforestphylogenomics/cloudforest_galaxy
repository with the tag <tag_name>. Use latest for the most recent build from master.

--sftp
Enable SFTP on 127.0.0.1:8022. Warning: the current implementation of
SFTP allows any users to access all SFTP files, so it should only be used in local,
single-user contexts.

--follow
Output logs after starting the container.

--stop
Bring down the CloudForest service

--usage
--help
Display this message.
EOF
}

# Don't allow sftp by default because its implementation in galaxy-docker is insecure.
# Should only be used for local instances
ALLOW_SFTP=false

# Follow log output after running container.
FOLLOW_LOGS=false

# Are we bringing the CloudForest down.
STOP_CONTAINER=false

# Optional arguments before the required tag and container name
while [[ $# -gt 0 ]]; do
    case $1 in
	"--sftp")
	    ALLOW_SFTP=true
	    shift
	    ;;
	"--tag")
        shift
        export CLOUDFOREST_TAG=$1
        shift
        ;;
    "--follow")
        FOLLOW_LOGS=true
        shift
        ;;
    "--stop")
        STOP_CONTAINER=true
        shift
        ;;
    "--help"|"--usage")
        print_help
        exit 0
        ;;
	*)
	    echo "Error: unrecognized option: $1"
	    exit 1
	    ;;
    esac
done

# Create .env file if it doesn't exist
if [[ ! -f .env ]]; then
    cp .env.example .env
fi

COMPOSE_FILE_ARGS=" -f docker-compose.yml"

if [[ $ALLOW_SFTP == "true" ]]; then
    COMPOSE_FILE_ARGS="$COMPOSE_FILE_ARGS -f docker-compose-sftp.yml "
fi

if [[ ! -z $CLOUDFOREST_TAG ]]; then
    COMPOSE_FILE_ARGS="$COMPOSE_FILE_ARGS -f docker-compose-remote.yml"
    docker-compose $COMPOSE_FILE_ARGS pull cloudforest
else
    COMPOSE_BUILD_ARGS="--build"
fi

if [[ $STOP_CONTAINER == "true" ]]; then
    docker-compose $COMPOSE_FILE_ARGS down
    exit 0
fi

# Read CRA credentials
read -p "CRA username: " TS_CRA_USERNAME
read -s -p "CRA password (characters will not be displayed as you type): " TS_CRA_PASSWORD
echo

export TS_CRA_USERNAME
export TS_CRA_PASSWORD

# Bring up service with docker-compose.
docker-compose $COMPOSE_FILE_ARGS up -d $COMPOSE_BUILD_ARGS

if [[ $FOLLOW_LOGS == "true" ]]; then
    docker logs -f "$CONTAINER_NAME"
fi
