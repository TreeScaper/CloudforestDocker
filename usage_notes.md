---
title: CloudForest Guide

---

CloudForest is a collection of phylogenomic tools residing in the workflow application [**Galaxy**](https://galaxyproject.org/). Both Galaxy and CloudForest are packaged within a [**Docker**](https://docker.com) container.

Containers package application, OS and dependency code into images that can be run from variety of computing environments. CloudForest via Docker will run on Linux, Windows and Mac OS.

## Preparing to Run CloudForest

### Docker Installation 

To run CloudForest, you will have to install Docker. Please follow these [**instructions**](https://www.docker.com/products/docker-desktop) to install Docker for your operating system.

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

If Docker is installed correctly you should see the following output:


    Hello from Docker!
    This message shows that your installation appears to be working correctly.

    To generate this message, Docker took the following steps:
    1. The Docker client contacted the Docker daemon.
    2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
        (amd64)
    3. The Docker daemon created a new container from that image which runs the
        executable that produces the output you are currently reading.
    4. The Docker daemon streamed that output to the Docker client, which sent it
        to your terminal.

    To try something more ambitious, you can run an Ubuntu container with:
    $ docker run -it ubuntu bash


## Running Docker CloudForest

### Running with No Data Persistence

Containers are by default ephemeral applications. When you run CloudForest using the following command no data is saved once the application is stopped.

> **NB: No data is saved between invocations using the default command.**

CloudForest is run with the docker run command with additional arguments (the command is all one line):

    docker run -d -p 8080:80 -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" -e "GALAXY_SLOTS=2" \ 
    cloudforestphylogenomics/cloudforest_galaxy:latest

What are the arguments?

* -d -p 8080:80

    CloudForest is a web application and like all web applications it listens on a port. In this case port 80. A docker container must map ports on the local machine (your computer) into the container. The -p argument maps the local port 8080 to the container port 80. You will use the 8080 port address when opening the application via the browser. The -d argument runs CloudForest as a daemon service.

* -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container"

    The -e flag sets environment variables inside the container. In this case we are telling CloudForest to run all tools on the local machine. It is possible to run tools on [HPC compute nodes or external clusters](https://github.com/bgruening/docker-galaxy-stable#Running-on-an-external-cluster-(DRM)). Using external clusters is outside the scope of this document.

* -e "GALAXY_SLOTS=2"

    This varible starts the application with 2 threads. If you have a local machine with multiple cores, you can increase this number.

* cloudforestphylogenomics/cloudforest_galaxy:latest

    This is the docker image. If you have pulled the image, docker will run with the locally cached image. If you have *not* pulled the image, docker will first pull the image from the docker hub and then run the container.

### Running the Image with Data Persistence

Docker does allow for data persistence over time. This is done by mapping local filespace into the container.

    docker run -d -p 8080:80 -v /home/user/galaxy_storage/:/export/ \
    -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" \
    -e "GALAXY_SLOTS=2" \ 
    cloudforestphylogenomics/cloudforest_galaxy:latest

Docker applications are *containers* running within your host computer operating system. If you are using an iMac, the host OS is macOS and the container is linux (CloudForest is always run within linux).

Running CloudForest with the -v option opens a tunnel from the host OS (macOS) to the container OS. In the above example the host path */home/user/galaxy_storage/* is directly connected to the container's folder */export*.

When CloudForest is run with the -v option, the database and data files are stored on your local host environment within the path */home/user/galaxy_storage*.

You can use any local path you would like (the left hand side of the colon), the */export/* path is mandatory. CloudForest is built to write all of its data to the container path */export/*.

## Using CloudForest

> NB: Docker commands are run from the terminal command line.

This is the recommended command for running CloudForest on macOS (assuming the user's name is *jdoe*):
    
    docker run -d -p 8080:80 -v /User/jdoe/galaxy_storage/:/export/ \
    -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" \
    -e "GALAXY_SLOTS=2" \ 
    cloudforestphylogenomics/cloudforest_galaxy:latest

This is the recommended command for running CloudForest on a linux distribution (assuming the user's name is *jdoe*):
    
    docker run -d -p 8080:80 -v /home/jdoe/galaxy_storage/:/export/ \
    -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" \
    -e "GALAXY_SLOTS=2" \ 
    cloudforestphylogenomics/cloudforest_galaxy:latest

This is the recommended command for running CloudForest on Windows 10 (assuming the user's name is *jdoe*):
    
    TODO

It will take a minute or two for CloudForest to start once you invoke the docker run command. 

If your computer has more than 4 cores, setting "GALAXY_SLOTS=4" is a good setting.

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