FROM bgruening/galaxy-stable:latest

LABEL maintainer="Thomas McGowan, mcgo0092@umn.edu"

ENV GALAXY_CONFIG_BRAND CloudForest

ADD tool_conf.xml $GALAXY_ROOT/config/
ADD tool.yml $GALAXY_ROOT/tool.yml
RUN install-tools $GALAXY_ROOT/tool.yml 

COPY welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
ADD welcome_bootstrap.min.css $GALAXY_CONFIG_DIR/web/welcome_bootstrap.min.css

RUN mkdir $GALAXY_ROOT/tools/treescaper
ADD treescaper.xml $GALAXY_ROOT/tools/treescaper
ADD treescaper_macros.xml $GALAXY_ROOT/tools/treescaper
ADD CLVTreeScaper $GALAXY_ROOT/tools/treescaper

ADD Galaxy-Workflow-Variation_in_Gene_Trees_UFB.ga $GALAXY_HOME/workflows/
RUN startup_lite && \
    /tool_deps/_conda/bin/galaxy-wait && \
    /tool_deps/_conda/bin/workflow-install --workflow_path $GALAXY_HOME/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD --publish_workflows


# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE 80/tcp
EXPOSE 21/tcp
EXPOSE 8800/tcp

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]