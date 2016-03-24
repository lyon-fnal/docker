# Docker for HEP Code Development and Analysis

**Abstract:** Development and execution environments are difficult to create and maintain. The traditional (old) way of using a machine configured by administrators or yourself is giving way to more agile environments, of which the current state-of-the-art are software *containers*. *Docker* is the most popular implementation of a container system. This document and repository offer an environment for Muon *g-2* development and execution using Docker containers allowing for ease of setup, reproducibility, and compatibility on practically any modern host computer. 

## The problem

The vast majority of current HEP computing resources, that is Grid resources, run Scientific Linux Version 6 (SL6). Fermilab offers a cluster of SLF6 (the Fermilab variant of SL) interactive nodes that may be used for code development and testing.  Such shared nodes are a good resource, but for many they are inconvenient. Many of us have powerful laptop machines or machines at the home institution that could be used for development and testing of HEP code. In general, most non-worker/non-server nodes do not run SL6 as it does not offer a compelling user-experience. Rather, Mac OSX and Ubuntu are found on most of our personal machines along with a few running Microsoft Windows. Creating and maintaining a development/testing environment for HEP experiment code (e.g. Muon *g-2* code) on such systems varies in difficulty from hard to impossible. 

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

A class of solutions involves somehow running Scientific Linux on a non-SL laptop, desktop, or other machine (this machine is called the *host*). Running both the host OS and SL simultaneously is a strategy that combines the advantages of the host machine OS with developing, building and testing HEP experiment code on the OS compatible with the Grid. A hybrid system may even allow the use of some development tools on the host (e.g. an IDE) that act on builds with SL. 





# Old stuff

* The images are below. See the subdirectory for more information - click on the image name to jump...

- [c67base](c67Base/README.md) - An image based off of Centos 6.7 (equivalent to Scientific Linux 6) with enough dependencies installed to run g-2 code, pop an X window, run git, and get a Kerberos ticket.

- [c67cvmfs](c67Cvmfs/README.md) - An image based off of c67base that makes the `/cvmfs/gm2.opensciencegrid.org` CVMFS repository available.

- [c67allinea](c67Allinea/README.md) - An image based off of c67cvmfs that includes Allinea Forge (debugger and profiler). Note that you will need a license file to run Allinea (license file not included).

- [c67spack](c67Spack/README.md) - An image based off of c67base that can make a development container for Spack (not for general use).

## Quick start

To build all of the docker images in this repository and spin
up a cvmfs container, do...

```bash
# Checkout the repository
cd somewhere
git clone https://github.com/lyon-fnal/docker-gm2.git
cd docker-gm2
export DOCKER_GM2=$PWD

# Build all of the docker images (takes awhile, lots of downloads)
make build-all

# Start a container that has CVMFS and can pop an X-window if necessary
cd c67Cvmfs
make cvmfs x11 shell
```

## Convenience scripts in Makefiles

For convenience, there are a series of hierarchical `Makefiles` that serve as scripts for running many docker functions. You must run `make` from the image's particular source subdirectory or use `make -C`. For example, if you want to build the `c67base` image, you would do,

```
cd <docker-gm2-directory>
cd c67Base
make build
```
or
```
make -C <docker-gm2-directory>/c67Base build
```

It may be a good idea to set an environment variable to the `docker-gm2` directory. See the quick start above for an example. Then you can do something like,
```bash
cd some-place
make -C $DOCKER_GM2/c67Cvmfs cvmfs x11 shell
```

There are a few functions you can run from the top level `docker-gm2` directory. For example,
```
cd <docker-gm2-directory>
make build-all
```
will build all of the images in one shot (recommended).

Do `make help` (from the particular directory) for more information or see the README in the particular directory. There are a couple of scripts involving the *xhyve* virtual machine for Mac OSX. See https://allysonjulian.com/setting-up-docker-with-xhyve/ .

### Common functions

Nearly all of the `Makefiles` support the following convenience commands (see above for how to run `make`; we assume that you are running in the proper directory or are using the `-C` flag)...

- `make build` - Build the image
- `make shell` - Spin up the container to the shell prompt (see below for features)

The following are options and can be added before `shell` in combinations (e.g. `make bkg x11 shell`)

- `make bkg shell` - Spin up the container, but run as a background daemon
- `make x11 shell` - Spin up the container and forward X11 to the host (you must have `socat` installed on the host - see below)

`Makefiles` in the subdirectories may add more options.

### Common features to `make shell`

- The container shell runs as the `gm2` user. When the `c67base` image is built, the `gm2` user is created with
your User and Group IDs that you have on your host machine (that way files written by the docker container
will have the correct ownership).

- Your `$HOME` on the host is accessible from within the container as the same path. Since the `gm2` user has the same UID/GID as the host, files you write from within the container to that directory (and subdirectories) are accessible by the host too. Having the paths the same makes it easy to share source files between an IDE running in the host and building that code within the container. You can set a different directory to be accessible as that path by overriding `$LOCAL_VOLUME`. Note that the volume must be accessible by the docker VM if applicable (e.g. Mac/Windows).

- The `/home/gm2/.bash_history` file is mirrored on the host as `$PWD/docker_bash_history`. That way your bash command history can live between calls to `make shell`. You can change the name and path of the command history file on the host side by setting `$DOCKER_HISTORY_FILE`.

- For a foreground `make shell` (`make shell` *without* `bkg`), the container will remove itself upon exit.


## Popping X11 windows

In the common functions section above, an option `x11` was described. This option has been tested on Mac El Capitan and Yosemite with the xhyve virtual machine. You need to have the `socat` program installed. The easiest way to get it is with Homebrew (http://brew.sh/). Once installed, you can run the following `brew` command...

```
brew install socat
```
