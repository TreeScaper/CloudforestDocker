#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No container version supplied"
    exit 1
fi

VERSION=$1

docker stop cf_galaxy && docker rm cf_galaxy &&
docker rmi tmcgowan/cloudforest_galaxy:$VERSION &&
rm cloudforest.tar.gz &&
cp ~/CodeProjects/JS/cloudforest_two/cloudforest.tar.gz . &&
docker build -t tmcgowan/cloudforest_galaxy:$VERSION . &&
docker run -d -p 8080:80 --name cf_galaxy -e "NONUSE=nodejs,proftp,reports" -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" -e "GALAXY_SLOTS=4" tmcgowan/cloudforest_galaxy:$VERSION &&
docker logs -f cf_galaxy
