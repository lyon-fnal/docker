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

<MORE NEEDS TO BE WRITTEN>


# Quick Start

Clone this github repository with

```bash
git clone https://github.com/lyon-fnal/docker-gm2.git
```

You need to run the `make` command below sitting in the directory that was created (e.g. `docker-gm2`). 

You need to have `docker` installed on your machine. The easiest way is to download the `docker toolbox` from https://www.docker.com/products/docker-toolbox . 

> NOTE: Docker will be coming out with a new version that will greatly simplify running on Mac/Windows. See the beta program at https://beta.docker.com/

To pop X-windows on a Mac, you will need `socat`. The easiest way to install it is with [Homebrew](http://brew.sh/). Install according to the instructions on that page. To install `socat` do,

```bash
brew install socat
```

## Getting help
Type `make` to see the main functions. 

## Starting CVMFS
You should first get CVMFS running (eventually, this will be automatic, but not at this point). Do,

```bash
make cvmfs-start
```

You should do

```
docker logs -f cvmfs_nfs_server
```

and watch and wait for 

```
Starting NFS services:                                     [  OK  ]
Starting NFS mountd:                                       [  OK  ]
Starting NFS daemon:                                       [  OK  ]
Starting RPC idmapd:                                       [  OK  ]
```

Note that the following message:

```
FATAL: Could not load /lib/modules/4.1.19-boot2docker/modules.dep: No such file or directory
```

is benign and can be ignored.

## Running development containers

Your current directory must be where you cloned `docker-gm2` (your current directory should have the top level `Makefile`). 

Once CMVFS is up, you can run development containers. 

```bash
make dev-shell
```

Runs a development shell. `/cvmfs` will be mounted and X11 forwarding will be set up. Also, if you are on a Mac, then `/Users` is accessible from within the container. You will be the `gm2` user in `/home/gm2`. There are several options that you can set with make variables (they may be combined)...

Specify a name for the container...

```
make NAME=myContainerName dev-shell
```

Specify a volume in the container. The `VOL` variable can specify a docker volume within the container. A docker volume persists for the life of the container (whether the container is running or has exited). Once the container is removed, then the volume is removed with it. If you don't specify `VOL`, then a default volume will be created with the name of the container. 

```
make VOL=/home/gm2/myruns dev-shell
```

Note that the directory will be owned by root. You will need to change ownership by running within the container,

```
sudo chown gm2 <dir>
```

You can also map directories on your host into the container. By using the syntax `VOL=pathOnHost:pathInContainer` . For example,

```
make VOL=$PWD/archive/oldStuff:/home/gm2/oldStuff dev-shell
```

You can load volumes from other containers (created by default or with `VOL=` into your new container with the `VOLS_FROM` option. Specify existing container names separated by spaces. For example,

```
make VOLS_FROM=old_container dev-shell
make VOLS_FROM="old_container1 old_contianer2" dev-shell
```

## Other shells

Along with `dev-shell`, you can use the following:

* `plain-shell`: Just X11 started
* `dev-shell`: X11 + CVMFS mounted
* `allinea-shell`: X11 + CVMFS + Allinea Forge (you'll need a license file)
* `igprof-shell`: X11 + CVMFS + Igprof profiler

Just replace `dev-shell` with the other shell in the examples above. 

## Archiving containers

You can archive a container, which means that container information, the container log, and data in any docker volumes, will be written to a tar file. 

```
make ARCHIVE=container_name archive
```

## More stuff to write

* Using Xcode with a container
* Monitoring



