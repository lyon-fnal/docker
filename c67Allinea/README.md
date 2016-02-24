# c67allinea

Image name: c67allinea

Centos 6.7 - Allinea

Creates an image based on *c67cvmfs* that installs Allinea Forge, which consists of the Map Profiler and DDT Debugger. For more information on Allinea, see http://www.allinea.com/

This image has the capabilities of the c67cvmfs image.

To run the container and Allinea Forge, you will need a license file. This file is not included in the repository.

The `Makefile` adds an `allinea` option to use before `shell`. It will make the license file available to the container. For example,

```
LICENSE_FILE=/path/to/licence_file make -C $DOCKER_GM2/c67Allinea allinea cvmfs x11 shell
```

Once the container starts and you set up your environment, you should
```
source ~/setup_allinea
```

You can then run `forge`, `ddt`, or `map`.
