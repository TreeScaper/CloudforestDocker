FROM bgruening/galaxy-stable:latest

LABEL maintainer="Thomas McGowan, mcgo0092@umn.edu"

ENV GALAXY_CONFIG_BRAND CloudForest

ADD tool_conf.xml $GALAXY_ROOT/config/

COPY welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
ADD welcome_bootstrap.min.css $GALAXY_CONFIG_DIR/web/welcome_bootstrap.min.css

ADD Galaxy-Workflow-Variation_in_Gene_Trees_UFB.ga $GALAXY_HOME/workflows/
RUN startup_lite && \
    /tool_deps/_conda/bin/galaxy-wait && \
    /tool_deps/_conda/bin/workflow-install --workflow_path $GALAXY_HOME/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD --publish_workflows

USER galaxy
RUN mkdir $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper-trees.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper-nldr.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper-dimest.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/treescaper_macros.xml $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/CLVTreeScaper $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/dimest_parameters.csv $GALAXY_ROOT/tools/treescaper
ADD ./treescaper_tool/nldr_parameters.csv $GALAXY_ROOT/tools/treescaper

RUN mkdir $GALAXY_ROOT/tools/iqtree
ADD ./iqtree_tool/iqtree.xml $GALAXY_ROOT/tools/iqtree
ADD ./iqtree_tool/iqtree_macros.xml $GALAXY_ROOT/tools/iqtree
ADD ./iqtree_tool/iqtree $GALAXY_ROOT/tools/iqtree
# Add for CloudForest datatype
ADD ./custom_src/datatypes_conf.xml $GALAXY_ROOT/config/
ADD ./custom_src/cloudforest.py $GALAXY_ROOT/lib/galaxy/datatypes/

# Add visualization code to galaxy
ADD cloudforest.tar.gz $GALAXY_ROOT/static/plugins/visualizations/
ADD cloudforest.tar.gz $GALAXY_ROOT/config/plugins/visualizations/

USER root
# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE 80/tcp
EXPOSE 21/tcp
EXPOSE 8800/tcp

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
