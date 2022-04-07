#!/bin/bash

if [[ $BUILD_VIZ == true ]]; then
    echo "$0 Building visualization package."
    cd ../CloudforestVisualization
    npm run package
    cd -
    cp ../CloudforestVisualization/cloudforest.tar.gz .
fi

if [[ $NO_UNPACK != true ]]; then
    echo "$0 Unpacking cloudforest tarball."
    rm -r cloudforest
    tar -xvzf cloudforest.tar.gz
fi

echo "$0 Copy files into container."
docker cp cloudforest/templates/cloudforest.mako  cloudforest:/galaxy-central/static/plugins/visualizations/cloudforest/templates/
docker cp cloudforest/static/bundle*.js cloudforest:/galaxy-central/static/plugins/visualizations/cloudforest/static
docker cp cloudforest/config/cloudforest.xml cloudforest:/galaxy-central/static/plugins/visualizations/cloudforest/config
docker cp cloudforest/templates/cloudforest.mako  cloudforest:/galaxy-central/config/plugins/visualizations/cloudforest/templates/
docker cp cloudforest/static/bundle*.js cloudforest:/galaxy-central/config/plugins/visualizations/cloudforest/static
docker cp cloudforest/config/cloudforest.xml cloudforest:/galaxy-central/config/plugins/visualizations/cloudforest/config

if [[ $RESTART_GALAXY == true ]]; then
    echo "$0 Restarting Galaxy."
    docker exec -it cloudforest supervisorctl restart galaxy:
fi
