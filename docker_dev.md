---
title: CloudForest Development
---

CloudForest is comprised of three separate code units:

1. TreeScaper

    The command line application
    
2. CloudForest Visualization

    JS code for visualizing TreeScaper output

3. CloudForest Docker

    Docker and ancillary files for bundling the application into a Galaxy workflow image 

## General Development Flow

![](CloudForestDevFlow.png)

## Github Repositories

### TreeScaper

The [TreeScaper](https://github.com/TreeScaper/TreeScaper) repo contains C++ code for producing CLVTreeScaper.
Currently, the "docker" branch uses github actions to automatically compile and generate the CLVTreeScaper executable as an artificate. This happens on any push to the branch. The status of the continuous integration can be seen ![CLI_Docker CI](https://github.com/TreeScaper/TreeScaper/workflows/CLI_Docker%20CI/badge.svg?branch=docker).

TreeScaper is compiled with a Makefile using g++ as the compiler. The CI action uses Ubuntu-18.04 as the compile environment.

CLAPack-3.2.1 is a library dependency for TreeScaper. The library is compiled and linked during the Makefile run.

### CloudForest Visualization

The [CloudForestVisualization](https://github.com/TreeScaper/CloudforestVisualization) repo contains primarily JS code. It produces a tar ball of code and configuration files for use as a Galaxy [visualization plugin](https://galaxyproject.org/develop/visualizations/).

The JS application relies on pure JS with the addition of [Plotly JS](https://plotly.com/javascript/) and [D3 JS](https://d3js.org/) for specific plots. Many of the more complex graphs and trees are rendered directly as 2D [canvas](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D) elements. This allows for hightly performant rendering.

[Webpack](https://webpack.js.org/) is used to bundle the JS code into a single, deployable application from multiple modules. In addition, Webpack allows for tree shaking. Using Webpack tree shaking, dead code paths can be removed from the final bundle. This minimizes the final size of the deployed application.

A release for this repo is the tarball *cloudforest.tar.gz*. This release artifact cannot be run on its own, instead it is an input into the final repo: CloudForestDocker.

### CloudForest Docker

The [CloudForestDocker](https://github.com/TreeScaper/CloudforestDocker.git) repo contains all the files needed to build a functional Docker image.

## Docker Hub