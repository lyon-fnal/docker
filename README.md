# docker-gm2

This repository is the source for docker images useful for code development and execution on the Muon *g-2* experiment (and likely others).

## Introduction

The images are (see their subdirectory for more information)...

- c67base - An image based off of Centos 6.7 (equivalent to Scientific Linux 6) with enough dependencies installed to run g-2 code, pop an X window, run git, and get a Kerberos ticket.

- c67cvmfs - An image based off of c67base that makes the `/cvmfs/gm2.opensciencegrid.org` CVMFS repository available.

- c67allinea - An image based off of c67cvmfs that includes Allinea Forge (debugger and profiler). Note that you will need a license file to run Allinea.

- c67spack - An image based off of c67base that can make a development container for Spack (not for general use).

## Convenience scripts

For convenience, there are a series of hierarchical `Makefiles` that serve as scripts for running many docker functions. You must run `make` from the image's particular source subdirectory or use `make -C`. For example, if you want to build the `c67base` image, you would do,

```
cd <docker-gm2-directory>
cd c67base
make build
```
or
```
make -C <docker-gm2-directory>/c67base build
```

It may be a good idea to set an environment variable to the `docker-gm2` directory. See below.

There are a few functions you can run from the top level `docker-gm2` directory. For example,
```
cd <docker-gm2-directory>
make build-all
```
will build all of the images in one shot (recommended).

Do `make help` (from the particular directory) for more information or see the README in the particular directory.

### Common functions

Nearly all of the images support the following convenience commands (see above for how to run `make`; we assume that you are running in the proper directory or are using the `-C` fiag)...

- `make build` - Build the image
- `make build-all` - Build all of the images. Your current directory must be the top of `docker-gm2`.
- `make shell` - Spin up the container to the shell prompt (see below for feature)

The following are options and can be added before `shell` in combinations (e.g. `make bkg x11 shell`)

- `make bkg shell` - Spin up the container, but run as a background daemon
- `make x11 shell` - Spin up the container and forward X11 to the host (you must have `socat` installed on the host)
