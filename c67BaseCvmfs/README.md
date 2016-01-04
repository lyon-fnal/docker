# c67BaseCvmfs

Image name: squark/c67basecvmfs

Centos 6.7 - Base - CVMFS

Creates an image from centos 6.7 that installs enough packages that you can build and run gm2 software (see c67Base) and install/mount the gm2 CVMFS UPS repository within the container. 

Unlike `squark/c67base`, this container comes with CVMFS built in and ready to go. On a Mac, it should work without needing to alter the docker-machine. 

To build this docker image, assuming you are following the git repository, do

```bash
# Create c67base
docker build -t squark/$(basename $PWD | tr A-Z a-z) .
```

To run a container with this image, do

```bash
docker run --privileged -t -i squark/c67basecvmfs
```

Note that the container must be run with the `--privileged` flag due to the use of FUSE within the container. 

Add other `-v` options to make more data volumes visible. For example, on your Mac add `-v /Users:/Users` (the `/Users` shared folder is added to your docker machine VM by the docker installation).

`/cvmfs/gm2.opensciencegrid.org` is mounted when the container is run. It may take many seconds for mount to complete. Note that as written, you start with an empty CVMFS cache every time you `docker run` the container. You may want to make a new image based off of this one that moves the cache to a persistent data volume outside of the container (though this may make CVMFS slow). An alternative is to `docker run` the container in the background (use `-d`), and then `docker attach` or `docker exec` to run multiple commands with the same CVMFS cache. Note that commands run with `docker exec` are not logged in `docker logs`. 


