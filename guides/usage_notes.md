# CloudForest User Guide #

CloudForest is a collection of phylogenomic tools residing in the workflow application [**Galaxy**](https://galaxyproject.org/). Both Galaxy and CloudForest are packaged within a [**Docker**](https://docker.com) container.

Containers package application, OS and dependency code into images that can be run from variety of computing environments. CloudForest via Docker will run on Linux, Windows and MacOS.

## Preparing to Run CloudForest

### Docker Installation 

To run CloudForest, you will have to install Docker. Please follow these [**instructions**](https://www.docker.com/products/docker-desktop) to install Docker for your operating system.

### Docker Pull and Run Commands

The CloudForest Docker image is stored on [**Docker hub**](https://hub.docker.com/repository/docker/cloudforestphylo/cloudforestgalaxy).

> **NB: Docker commands are run from the terminal command line.**

#### Pulling the Image

You can download the image to your computer with the following [**command**](https://docs.docker.com/engine/reference/commandline/pull/):

    docker pull cloudforestphylo/cloudforestgalaxy:latest

This command contacts Docker hub and pulls down the latest image of CloudForest.

You can verify the download with the command:

    docker images

You will see something like this:

    cloudforestphylo/cloudforestgalaxy  latest  160a642eee15  4 days ago  2.12GB

The number _160a642eee15_ is an arbitraty ID assigned to the container by Docker. You do not have to use the ID number.  

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

#### Docker Prune

It may be necessary to clean your docker installation periodically.
Read about the [**prune**](https://docs.docker.com/engine/reference/commandline/system_prune/) command in the docker documentation. This command will remove all unused data and docker objects. Be careful using this command especially if you have not moved data files from the container into your local file space.

## Running Docker CloudForest

### `run.sh`

A simple script `run.sh` is provided for starting and stopping CloudForest. To run with the latest image from Docker Hub:

	./run.sh --tag latest

If the `--tag` argument is left out, it will build the image locally:

    ./run.sh

A volume is created for data persistence by the name provided in `.env`, which is automatically created from `.env.example`. The volume can be removed with `docker volume rm <volume name>`.

The `--sftp` option can be used to enable SFTP for file-upload, which currently should only be used in a local, single-user context. See the `Uploading Files` section below.

The `run.sh` simply manages these user options (`./run.sh --usage` will display all options) and runs docker-compose, providing the necessary combination of docker-compose yaml files. The base docker-compose configuration is `docker-compose.yml`. Here you'll find environment variables, port mappings, and volumes configuration. Many docker-compose options translate to command-line options that would be used with `docker run`. Explanations for some of the command-line analogues we use can be found below.

* -d -p 8080:80

     CloudForest is a web application and like all web applications it listens on a port. In this case port 80. A docker container must map ports on the local machine (your computer) into the container. The *__-p__* argument maps the local port 8080 to the container port 80. You will use the 8080 port address when opening the application via the browser. The *__-d__* argument runs CloudForest as a daemon service.

* \--name cloudforest

    The running container is given a name with this argument. Multiple containers can run at the same time on any one machine. By default each container will be given an id something like *63289272e49b*. Use the *__\--name__* argument to give the container a good, memorable name. This name will be used to stop, or if necessary directly access, the container.

* -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container"

    The *__-e__* flag sets environment variables inside the container. In this case we are telling CloudForest to run all tools within the container. It is possible to run tools on [HPC compute nodes or external clusters](https://github.com/bgruening/docker-galaxy-stable#Running-on-an-external-cluster-(DRM)). Using external clusters is outside the scope of this document.

* -e "GALAXY_SLOTS=2"

    This varible starts the application with 2 threads. If you have a local machine with multiple cores, you can increase this number.

* cloudforestphylo/cloudforestgalaxy:latest

    This is the docker image. If you have pulled the image, docker will run with the locally cached image. If you have *not* pulled the image, docker will first pull the image from the docker hub and then run the container.

Docker does allow for data persistence over time. This is done by mapping a docker volume into the container.

    docker run -d -p 8080:80 --name cloudforest --mount source=cloudforest-volume,target=/export/ -e "GALAXY_DESTINATIONS_DEFAULT=local_no_container" -e "GALAXY_SLOTS=2" cloudforestphylo/cloudforestgalaxy:latest

The *__--mount__* option is used for volume mapping.

    --mount source=cloudforest-volume,target=/export/

Volumes can be created like so:

	docker volume create cloudforest-volume

Docker applications are containers running within your host computer operating system. If you are using a Mac, the host OS is MacOS and the container's OS is Linux (CloudForest is always run within Ubuntu).

Running CloudForest in this way mounts the Docker volume to the *__/export__* path within connected to the container's filesystem. This is where the Galaxy database, data, and configuration files are stored.

Each time you start CloudForest using the same *__--mount__* option, CloudForest will use the database, data, and configuration files found on the volume. This gives you data permanence across CloudForest starts and stops.

You can create and use multiple Docker volumes for completely separate CloudForest data installations.

### Uploading Files

Galaxy documentation [recommends](https://galaxyproject.org/tutorials/upload/) only using the basic local file upload for small numbers of files. For many files, or larger files FTP is recommended. Due to some limitations with running an FTP server within Docker, SFTP is a more viable method for uploading files in bulk.

#### SFTP (Warning: this option comes with security considerations - see below.)

This should not be used on an host that allows incoming network traffic, over has multiple users. In the current implementation of galaxy-docker from which CloudForest is built, the entire containerized Galaxy installation including uploaded data may be downloaded via SFTP by anyone with an account on the instance. For this reason it is only suitably run on a personal machine, for the time being.

The `-s` flag for `run.sh` may be used to enable SFTP on the instance. The SFTP port is forwarded to 8022 only on IP 127.0.0.1, just in case it is run on a publicly accessible host.

[FileZilla](https://filezilla-project.org/) or [sftp](https://man7.org/linux/man-pages/man1/sftp.1.html) may be used to upload files to the instance.

#### FileZilla Steps

1. Download the FileZilla client from https://filezilla-project.org.
2. With FileZilla open, click the Site Manager button in the top left corner.
3. Click **New site** to create a new site and name it however you like, e.g. "CloudForest".
4. Select **Protocol** -> **SFTP - SSH File Transfer Protocol**.
5. Enter **127.0.0.1** for **Host**.
6. Enter **8022** for **Port**.
7. Select **Ask for password** for **Logon Type**.
8. Enter your galaxy username.
9. Select **OK** and FileZilla will prompt for your password and establish a connection.

You should see on the right a hierarchy of directories `/export/ftp/<your username>`. Navigate to the files on your host machine in the left-hand pane, and drag the files you want to upload to the right-hand pane.

Once the files have been uploaded to the FTP location, they must still be imported into your history. This is done within Galaxy by navigating in the tool pane to `Get Data` -> `Upload File` -> `Choose FTP file`. Here you should see the files you uploaded with FileZilla.

#### sftp

`sftp` is a command-line program for uploading/downloading that is likely already installed if your machine is running MacOS or Linux. File upload can be achieved with the following command:

	sftp -P 8022 -o User=<your username> 127.0.0.1 <<< $'put <path to your files>'

File globbing may be used here for the filepath, e.g. `/my/text/files/*.txt` will upload all `.txt` files in that directory.

## Using CloudForest

> NB: Docker commands are run from the terminal command line.

This is the recommended command for running CloudForest on MacOS and Linux platforms:
    
    ./run.sh --tag latest

This is the recommended command for running CloudForest on Windows 10 (assuming the user's name is *jdoe*):
    
    TODO

It will take a minute or two for CloudForest to start once you invoke the docker run command. 

If your computer has more than 4 cores, setting "GALAXY_SLOTS=4" in `docker-compose.yml` is a good setting.

1. Open a browser
1. Enter the address<br>

    http://localhost:8080

1. Click on "Login or Register"
1. You can register a user name, if more than one person is going to access CloudForest. If not, use
    
    **Public name or Email Address**: admin

    **Password**: admin
1. Click on Login

When you wish to stop the application use the folowing command at the terminal:

    docker stop cloudforest

Where *cloudforest* is the name used in the \--name argument.

### A Brief CloudForest Tour

 This is the initial workspace screen:<br>
    
![](FirstScreen.png)

The right panel shows your processing history. Each entry in the history is a file: either imported from your local file space or the results of a computation.

The center panel will contain all the options for a selected tool. You will launch the tool by clicking **Execute** after specifying options.

The left panel contains all the tools available for use.

<p align="center">&#9672;</p>

You access all tools from the left panel, click on **CloudForest** to open the subpanel:<br>
![](Tools.png)

Click on any tool to show its options:<br>
![](TreeScaper-Trees.png)

In this example, the options for the **-trees** argument are made available. The first history entry, **cats_subsampled.boottrees** has been uploaded to CloudForest and is the start of the data analysis.

Clicking on **Execute** starts the compute job. In the right history pane, you can see the four outputs that will be produced from the job run. Once the entries change from gray to green, the job is complete and the outputs are ready for further processing or inspection.

For instance, you can run NLDR on history entry 5 **Distance Matrix from data 1** to generate a non-linear dimension reduction of the generated trees. 

![](Execute.png)

<p align="center">&#9672;</p>

#### Workflows ####

There are constructed workflows available for use. These workflows string together mutliple tools with common options selected. You can override the configured options before starting a workflow.

Reading from left to right:
- Start with a set of bootstrapped trees, you will select the specific input
- Generate a distance matrix
- Generate a 20D NLDR matrix from the distance matrix
- Generate an affinity matrix from the 20D matrix
- Run community detection based on the generated affinity matrix

Once the workflow starts, barring errors, it will run until the final output is produced. All intermediate datasets will be saved and will be available for inspection or as inputs to other compute jobs. 

There will be ten data sets after the workflow finishes. Each asterix in the tools boxes shown below is a data file. 

![](Workflow_20D.png)

<p align="center">&#9672;</p>

### Inspect Data Files ###

The raw data of a computed data set can be viewed from within CloudForest.
On any history entry, click on the eye icon.
![](eye.png)

This will open the raw data within a computed data set. The data will appear within the central pane.

![](raw_data.png)



### Visualizations ###

CloudForest datasets can be visualized directly from the CloudForest application. Within each data entry, you can click on the *Visualize this data* button

![](viz_select.png)

Then click on the *CloudForest Visualizations* link in the center pane. This will open the CloudForest visualization application.

![](viz_categories.png)

The available plots and visualizations are arranged in three categories:
- NLDR Plots
    - 2D
    - 3D
    - High Dimension Plots
- Trees and Matrices
    - Treesets (Newick)
    - Consensus Tree
    - Affinity Matrix
    - Covariance Matrix
- Communtiy Detection
    - CD Results



Click on any dropdown item to visualize the file. For example, choosing *NDLR Coordinates: 3D from data 5* will produce a fully interactive 3D plot

![](3dnldr.png)

In this screen capture the trees have been color coded based on the x-axis. Highlighting a data point will let you know what tree is associated with the point. Click on the data point will open the tree itself.

![](multi_viz.png)
