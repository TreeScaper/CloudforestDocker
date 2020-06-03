docker stop cf_galaxy && docker rm cf_galaxy &&
docker rmi tmcgowan/cloudforest_galaxy:0.5.4 &&
rm cloudforest.tar.gz &&
cp ~/CodeProjects/JS/cloudforest_two/cloudforest.tar.gz . &&
docker build -t tmcgowan/cloudforest_galaxy:0.5.4 . &&
docker run -d -p 8080:80 --name cf_galaxy -e "NONUSE=nodejs,proftp,reports" -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" -e "GALAXY_SLOTS=4" tmcgowan/cloudforest_galaxy:0.5.4 &&
docker logs -f cf_galaxy
