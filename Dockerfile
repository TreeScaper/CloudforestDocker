FROM bgruening/galaxy-stable:latest

LABEL maintainer="Thomas McGowan, mcgo0092@umn.edu"

ENV GALAXY_CONFIG_BRAND CloudForest

ADD tool_conf.xml $GALAXY_ROOT/config/
ADD tool.yml $GALAXY_ROOT/tool.yml
# ADD job_conf.xml $GALAXY_CONFIG_DIR/
RUN install-tools $GALAXY_ROOT/tool.yml 

COPY welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
ADD welcome_bootstrap.min.css $GALAXY_CONFIG_DIR/web/welcome_bootstrap.min.css

ADD Galaxy-Workflow-Variation_in_Gene_Trees_UFB.ga $GALAXY_HOME/workflows/
RUN startup_lite && \
    /tool_deps/_conda/bin/galaxy-wait && \
    /tool_deps/_conda/bin/workflow-install --workflow_path $GALAXY_HOME/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD --publish_workflows

RUN mkdir $GALAXY_ROOT/tools/treescaper
ADD treescaper-trees.xml $GALAXY_ROOT/tools/treescaper
ADD treescaper-nldr.xml $GALAXY_ROOT/tools/treescaper
ADD treescaper-dimest.xml $GALAXY_ROOT/tools/treescaper
ADD treescaper_macros.xml $GALAXY_ROOT/tools/treescaper
ADD CLVTreeScaper $GALAXY_ROOT/tools/treescaper
ADD dimest_parameters.csv $GALAXY_ROOT/tools/treescaper
ADD nldr_parameters.csv $GALAXY_ROOT/tools/treescaper
# Patch broken iqtree xml TODO: open a PR 
ADD iqtree.xml /galaxy-central/database/shed_tools/toolshed.g2.bx.psu.edu/repos/iuc/iqtree/973a28be3b7f/iqtree/
# Add for CloudForest datatype
ADD datatypes_conf.xml $GALAXY_ROOT/config/
ADD cloudforest.py $GALAXY_ROOT/lib/galaxy/datatypes/

# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE 80/tcp
EXPOSE 21/tcp
EXPOSE 8800/tcp

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
