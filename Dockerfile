FROM bgruening/galaxy-stable:19.09

LABEL maintainer="Reid Wagner, wagnerr@umn.edu"

ENV GALAXY_CONFIG_BRAND CloudForest

ADD tool_conf.xml $GALAXY_ROOT/config/

COPY welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
ADD welcome_bootstrap.min.css $GALAXY_CONFIG_DIR/web/welcome_bootstrap.min.css

ADD Galaxy-Workflow-Example_CloudForest_Workflow.ga $GALAXY_HOME/workflows/
RUN startup_lite && \
    /tool_deps/_conda/bin/galaxy-wait && \
    /tool_deps/_conda/bin/workflow-install --workflow_path $GALAXY_HOME/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD --publish_workflows

USER galaxy
RUN mkdir $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper-trees.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper-cra.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper-nldr.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper-community.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper-affinity.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper-dimest.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper_macros.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/CLVTreeScaper $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/CLVTreeScaper2 $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/dimest_parameters.csv $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/nldr_parameters.csv $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/subsample.py $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/clean_header.py $GALAXY_ROOT/tools/treescaper
RUN mkdir -p $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/treescaper-trees.xml $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/treescaper-cra.xml $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/treescaper-nldr.xml $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/treescaper-community.xml $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/treescaper-affinity.xml $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/treescaper-dimest.xml $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/treescaper_macros.xml $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/CLVTreeScaper $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/CLVTreeScaper2 $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/dimest_parameters.csv $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/nldr_parameters.csv $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/subsample.py $GALAXY_ROOT/treescaper_artifacts/tools/treescaper
ADD ./treescaper_tool/clean_header.py $GALAXY_ROOT/treescaper_artifacts/tools/treescaper

RUN mkdir $GALAXY_ROOT/tools/cloudforest_cat
ADD ./cloudforest_cat_tool/cloudforest_cat.xml $GALAXY_ROOT/tools/cloudforest_cat

RUN mkdir $GALAXY_ROOT/tools/iqtree
ADD ./iqtree_tool/iqtree.xml $GALAXY_ROOT/tools/iqtree
ADD ./iqtree_tool/iqtree_macros.xml $GALAXY_ROOT/tools/iqtree
ADD ./iqtree_tool/iqtree $GALAXY_ROOT/tools/iqtree
# Add for CloudForest datatype
ADD ./custom_src/datatypes_conf.xml $GALAXY_ROOT/config/
ADD ./custom_src/cloudforest.py $GALAXY_ROOT/lib/galaxy/datatypes/
ADD ./custom_src/export_user_files.py /usr/local/bin/export_user_files.py

# Add visualization code to galaxy
RUN mkdir $GALAXY_ROOT/treescaper_artifacts/viz
ADD cloudforest.tar.gz $GALAXY_ROOT/treescaper_artifacts/viz

USER root

# This is needed due to an outdated GPG key used for yarn
RUN apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

# Install dependency for CLVTreeScaper2
RUN apt-get update && apt-get install -y libpugixml1v5

# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE 80/tcp
EXPOSE 21/tcp
EXPOSE 8800/tcp

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
