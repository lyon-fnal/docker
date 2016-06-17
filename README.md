# Docker for HEP Code Development and Analysis

**Abstract:** Development and execution environments are difficult to create and maintain. The traditional way of using a machine configured by administrators or yourself is giving way to more agile environments, of which the current state-of-the-art are software *containers*. Today, *Docker* is the most popular implementation of a container system. This document and repository offer an environment for Muon *g-2* code development and execution using Docker containers allowing for ease of setup, reproducibility, and compatibility on practically any modern host computer. 

## The problem

The vast majority of current HEP computing resources, that is Grid resources, run Scientific Linux Version 6 (SL6). Fermilab offers a cluster of SLF6 (the Fermilab variant of SL) interactive nodes that may be used for code development and testing.  Such shared nodes are a good resource, but they are inconvenient for many. Many of us have powerful laptop machines or machines at the home institution that could be used for development and testing of HEP code. In general, the machine in front of a user does not run SL6 as that OS does not offer a compelling user-experience. Rather, Mac OSX and Ubuntu are found on most of our personal machines along with a few running Microsoft Windows. Creating and maintaining a development/testing environment for HEP experiment code (e.g. Muon *g-2* code) on such systems varies in difficulty from hard to impossible. 

* Ubuntu is Linux like SL, but uses a set of system libraries and tools that are different or at different versions than those used by SL6. 

* Apple's Mac OSX is a variant of Unix that is similar to Linux, but with very significant differences. 

* Microsoft Windows is not like Linux at all, and though there are applications like Cygwin that add Linux-like compatibility, they are not for the faint-of-heart. 

The *art* Framework team tries to mitigate some of these problems by delivering a near-complete set of applications and tools needed to build and run *art* based code on SL6 and MacOS. But there are caveats for non-SL development. 

* Ubuntu: Some users have been able to build the *art* tools on Ubuntu, making a development environment there for HEP code. But Ubuntu is not supported by the art team. 

* Mac OSX: With non-trivial effort, the art team has made Mac builds of *art* tools and dependencies, so Macs could be used for development. But new security restrictions in Mac OSX 11 (El Capitan) irreversibly breaks that work.

* Windows: Since Windows is so different from Linux, no attempts have been made to use such machines for HEP code development. 

For the systems above where HEP development is possible, build products (executables and libraries) are not compatible with SL6 systems. To run on the Grid, one must reproduce the development environment on a genuine SL6 node and build there to produce Grid compatible software. 

In a nutshell, the problem is how to use a non-Scientific Linux machine (desktop, laptop, node at home institution) to develop, build and test HEP experiment code. 

## Possible solutions

A class of solutions involves somehow running Scientific Linux on a non-SL laptop, desktop, or other machine (this machine is called the *host*). Running both the host OS and SL simultaneously is a strategy that combines the advantages of the host machine OS with developing, building and testing HEP experiment code on the OS compatible with the Grid. A hybrid system may even allow the use of some development tools on the host (e.g. an IDE) that acts on builds with SL. Currently, there are two main ways to simultaneously run SL6 within another OS: virtual machines and docker containers. 


### Virtual machines

Running a virtual machine means running an application that emulaes a computer within your computer. This virtual machine (VM) may run any operating system that the application can handle. While this idea may seem very inefficient, in fact modern processors have virtualization features that dramatically reduce the overhead. Oracle's VirtualBox is a widely used free virtual machine application. But VirtualBox only sets up the machine emulation layer. The user must find an installation image for the OS to run within the VM.Typically, these images come with very few user level programs installed. So one must use a package manager specific to the OS running on the VM (called the "guest"), like *yum* or *apt-get*, and install programs and libraries necessary for development and execution. Fortunately, an application that lives on top of VirtualBox, called *Vagrant*, allows a user to pull installation images from a cloud repository and provision (install extra packages) with a script. 

Problems with this straight Virtual Machine approach are:

-- more needs to be written here --


# Installation

Clone this github repository with

```bash
git clone https://github.com/lyon-fnal/docker-gm2.git
```

You need to have `docker` installed on your machine. The easiest way is to download the `docker toolbox` from https://www.docker.com/products/docker-toolbox . 

> NOTE: Docker will be coming out with a new version that will greatly simplify running on Mac/Windows. See the beta program at https://beta.docker.com/

To pop X-windows on a Mac, you will need `socat`. The easiest way to install it is with [Homebrew](http://brew.sh/). Install according to the instructions on that page. To install `socat` do,

```bash
brew install socat
```

## Starting up

Open a terminal window and do,

```
source /path/to/docker-gm2/setup_docker
```

You can run this script safely multiple times from different terminal windows. It will,

* If not already done, set up an alias IP address for your loopback network interface (see ifconfig lo0). The default alias is 192.168.50.1 . This alias will allow docker containers to easily connect to localhost on your host
 
* Start socat and XQuartz if they are not already running 

* Create the common CVMFS cache volume container if it does not exist already

* If not already running, start the `cvmfs_nfs_server` docker container to serve CVMFS to other containers

* Setup environment variables for help with running docker commands, see below

## Starting containers

There are a lot of things to remember when starting containers. The `setup_docker` script above will define several environment variables to help you. 

### Configurations
There are several "out of the box" configurations you can run. See the output of `setup_docker` for a list. These environment variables are enough to `docker run` the container without other arguments. For example, to start a centos 6.7 development shell with `/Users/${USER}` mapped into the container, X11 ready, and CVMFS mounted, do

```
docker run $D_DEVSHELL
```

In practice, you should always give other options, like 

```
docker run --name=myAnalysis -v /home/gm2/myAnalysis $D_DEVSHELL
```

### Saving bash history
It is often useful to retain your bash history and perhaps use it in future containers. The `d_h <history filename>` bash function creates a file in the current directory to hold the bash history and sets the `$D_H` environment variable with the needed `docker run` options to map it onto `.bash_history` in the container. For example,

```
d_h analysisBashHistory ; docker run $D_H --name=myAnalysis -v /home/gm2/myAnalysis $D_DEVSHELL
```

### Docker run components

The `setup_docker` script sets environment variables from which you can build a more generic `docker run` command. For example, if you have an image called `myImage`, and you want X11 to work (assuming the image has X11 installed in it), you can do

```
docker run ... $D_X11 myImage
```

A list of the component variables is printed when you run `setup_docker`. 

## Listing containers

The `docker ps` command gets hard to read when a container exposes lots of ports. The command `d_ps` removes that column, making for an easy to read list. `d_pss` adds sizes to the list (can be slow). 




