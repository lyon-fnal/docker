# c67Cvmfs

Image name: c67cvmfs

Centos 6.7 - CVMFS

Creates an image based on *c67base* that installs and mounts the gm2 CVMFS UPS repository within the container.

Unlike `c67Base`, this container comes with CVMFS built in and ready to go. On a Mac, it should work without needing to alter the docker-machine.

The `Makefile` in this directory adds the `cvmfs` option to use in front of `shell`. That is, for example,

```
make -C $DOCKER_GM2/c67Cvmfs cvmfs x11 shell
```

The `cvmfs` option checks for a "data volume container" named `cvmfs_cache` (for information see [here](https://docs.docker.com/engine/userguide/containers/dockervolumes/) and scroll down to "Creating and mounting a data volume container"). If `cvmfs_cache` does not exist, the container will be created. The `cvmfs_cache` data volume container is then used to hold the CVMFS cache. Using the data volume container means that the CVMFS cache will persist between `make cvmfs shell` calls.

If you do not give the `cvmfs` option, then the CVMFS cache is created and filled every time you run `make shell`.
