---
title: CloudForest Guide

---

CloudForest is a collection of phylogenomic tools residing in the workflow application [**Galaxy**](https://galaxyproject.org/). Both Galaxy and CloudForest are packaged within a [**Docker**](https://docker.com) container.

Containers package application, OS and dependency code into images that can be run from variety of computing environments. CloudForest via Docker will run on Linux, Windows and Mac OS.

## Preparing to Run CloudForest

### Docker Installation 

Of course, to run CloudForest, you will have to install Docker. Please follow these [**instructions**](https://www.docker.com/products/docker-desktop) to install Docker for your operating system.

### Docker Pull and Run Commands

The CloudForest Docker image is stored on [**Docker hub**](https://hub.docker.com/repository/docker/cloudforestphylogenomics/cloudforest_galaxy).

> **NB: Docker commands are run from the terminal command line.**

#### Pulling the Image

You can download the image to your computer with the following [**command**](https://docs.docker.com/engine/reference/commandline/pull/):

    docker pull cloudforestphylogenomics/cloudforest_galaxy:latest

This command contacts Docker hub and pulls down the latest image of CloudForest.

You can verify the download with the command:

    docker images

You will see something like this:

    cloudforestphylogenomics/cloudforest_galaxy  latest  160a642eee15  4 days ago  2.12GB

#### Running a Docker Image

In general you run any image with the following [**command**](https://docs.docker.com/engine/reference/commandline/run/):

    docker run hello-world

This is an actual run command that tests your Docker installation.

## Running Docker CloudForest

### Running with No Data Persistence

Containers are by default ephemeral applications. When you run CloudForest using the following command no data is saved once the application is stopped.

> **NB: No data is saved between invocations using the default command.**

CloudForest is run with the docker run command with additional arguments (the command is all one line):

    docker run -d -p 8080:80 -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" -e "GALAXY_SLOTS=4" \ 
    cloudforestphylogenomics/cloudforest_galaxy:latest

What are the arguments?

* -d -p 8080:80

    The Galaxy workflow engine is a web application and like all web applications it listens on a port. In this case port 80. A docker container must map ports on the local machine (your computer) into the container. The -p argument maps the local port 8080 to the container port 80. You will use the 8080 port address when opening the application via the browser. The -d argument runs CloudForest as a daemon service.

* -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container"

    The -e flag sets environment variables inside the container. In this case we are telling Galaxy to run the CloudForest applications on the local machine. It is possible to run tools on [HPC compute nodes or external clusters](https://github.com/bgruening/docker-galaxy-stable#Running-on-an-external-cluster-(DRM)). Using external clusters is outside the scope of this document.

* -e "GALAXY_SLOTS=4"

    This varible starts the application with 4 threads. If you have a local machine with multiple cores, you can increase this number.

* cloudforestphylogenomics/cloudforest_galaxy:latest

    This is the docker image. If you have pulled the image, docker will run with the locally cached image. If you have *not* pulled the image, docker will first pull the image from the docker hub and then run the container.

### Running the Image with Data Persistence

Docker does allow for data persistence over time. This is done by mapping local filespace into the container.

Coming soon to a document near you...

    docker run -d -p 8080:80 -v /home/user/galaxy_storage/:/export/ \
    -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" \
    -e "GALAXY_SLOTS=4" \ 
    cloudforestphylogenomics/cloudforest_galaxy:latest

## Using CloudForest

It will take a minute or two for CloudForest to start once you invoke the docker run command. 

1. Open a browser
1. Enter the address<br>

    http://localhost:8080

1. Click on "Login or Register"
1. You can register a user name, if more than one person is going to access CloudForest. If not, use
    
    Public name or Email Address: admin

    Password: admin
1. Click on Login

    This is the initial workspace screen:<br>
    
    ![](FirstScreen.png)