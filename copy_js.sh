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

docker cp custom_src/datatypes_conf.xml cloudforest:/galaxy-central/config
docker cp custom_src/datatypes_conf.xml cloudforest:/export/galaxy-central/config

docker cp cloudforest/static/bundle*.js            cloudforest:/galaxy-central/static/plugins/visualizations/cloudforest/static
docker cp cloudforest/templates/cloudforest.mako   cloudforest:/galaxy-central/config/plugins/visualizations/cloudforest/templates/
docker cp cloudforest/static/bundle*.js            cloudforest:/galaxy-central/config/plugins/visualizations/cloudforest/static
docker cp cloudforest/config/cloudforest.xml       cloudforest:/galaxy-central/config/plugins/visualizations/cloudforest/config

docker cp treescaper_tool/CLVTreeScaper            cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/CLVTreeScaper2           cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/clean_header.py          cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/dimest_parameters.csv    cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/nldr_parameters.csv      cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/subsample.py             cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-affinity.xml  cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-community.xml cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-cra.xml       cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-dimest.xml    cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-nldr.xml      cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-trees.xml     cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper2-trees.xml     cloudforest:/export/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper_macros.xml    cloudforest:/export/galaxy-central/tools/treescaper

docker cp tool_conf.xml    cloudforest:/export/galaxy-central/config

docker cp treescaper_tool/CLVTreeScaper            cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/CLVTreeScaper2           cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/clean_header.py          cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/dimest_parameters.csv    cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/nldr_parameters.csv      cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/subsample.py             cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-affinity.xml  cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-community.xml cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-cra.xml       cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-dimest.xml    cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-nldr.xml      cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper-trees.xml     cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper2-trees.xml     cloudforest:/galaxy-central/tools/treescaper
docker cp treescaper_tool/treescaper_macros.xml    cloudforest:/galaxy-central/tools/treescaper

docker cp tool_conf.xml    cloudforest:/galaxy-central/config

if [[ $RESTART_GALAXY == true ]]; then
    echo "$0 Restarting Galaxy."
    docker exec -it cloudforest supervisorctl restart galaxy:
fi
