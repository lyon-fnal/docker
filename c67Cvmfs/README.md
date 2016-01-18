# c67BaseCvmfs

Image name: squark/c67cvmfs

Centos 6.7 - CVMFS

Creates an image from centos 6.7 that installs enough packages that you can build and run gm2 software (see c67Base) and install/mount the gm2 CVMFS UPS repository within the container. 

Unlike `squark/c67base`, this container comes with CVMFS built in and ready to go. On a Mac, it should work without needing to alter the docker-machine. 

To build this docker image, assuming you are following the git repository, do

```bash
# Create c67base
docker build -t squark/$(basename $PWD | tr A-Z a-z) .
```

To run a container with this image, do

```bash
docker run --privileged -t -i squark/c67cvmfs
```

Note that the container must be run with the `--privileged` flag due to the use of FUSE within the container. 

Add other `-v` options to make more data volumes visible. For example, on your Mac add `-v /Users:/Users` (the `/Users` shared folder is added to your docker machine VM by the docker installation).

`/cvmfs/gm2.opensciencegrid.org` is mounted when the container is run. It may take many seconds for mount to complete. Note that as written, you start with an empty CVMFS cache every time you `docker run` the container. This will be very inefficient as will you have to re-populate the cache on every run of the container. One way to mitagate is to `docker run` the container in the background (use `-d`) and then `docker attach` or `docker exec` to run multiple commands within that container and with the same CVMFS cache. Note that commands run with `docker exec` are not logged in `docker logs`. 

Another way to re-use a CVMFS cache is to create a "data volume container" (see near the bottom of https://docs.docker.com/engine/userguide/dockervolumes/) with,

```bash
docker create -v /var/cache/cvmfs \ 
               --name cvmfsPersist \
                squark/c67cvmfs /bin/true
```

Now start the container with,

```bash
docker run -i -t --privileged --volumes-from cvmfsPersist \
       squark/c67cvmfs
```

If you exit the container and start it again with the same command, you will be re-using the CVMFS cache and you will find things to be very fast. 

Note that apparently you cannot run more than one container **simultaneously** accessing the same CVMFS cache. The cache keeps track of the cvmfs process accessing `/var/cache/cvmfs` and will not allow another one to mount until the process exits (e.g. the container exits). For example,

```bash
# Start a container in the background
$ docker run -i -t -d --privileged --volumes-from cvmfsPersist  squark/c67cvmfs
b910f28b41bae14bd0c76d3c335d053505ab0737a2c4346718746b4c64cadd58

# Watch CVMFS mount
$ docker logs -t b9
2016-01-04T08:35:07.668529020Z CernVM-FS: running with credentials 499:497
2016-01-04T08:35:08.211937225Z CernVM-FS: loading Fuse module... done
2016-01-04T08:35:08.213760246Z CernVM-FS: mounted cvmfs on /cvmfs/gm2.opensciencegrid.org

# Let's try to run another simultaneous container accessing the same CVMFS cache 
$ docker run -i -t  --privileged --volumes-from cvmfsPersist  squark/c67cvmfs
Repository gm2.opensciencegrid.org is already mounted on /cvmfs/gm2.opensciencegrid.org
# You will not be able to mount CVMFS in this container

# Exit out of the background container
$ docker attach b9
[root@b910f28b41ba /]# exit

# And try another container now that nothing is running
# It will work and note that the cache is still populated!!
$ docker run -i -t  --privileged --volumes-from cvmfsPersist  squark/c67cvmfs
CernVM-FS: running with credentials 499:497
CernVM-FS: loading Fuse module... done
CernVM-FS: mounted cvmfs on /cvmfs/gm2.opensciencegrid.org
[root@bab281a9dc09 /]# cvmfs_talk cache size
gm2.opensciencegrid.org:
Current cache size is 192MB (202084987 Bytes), pinned: 68MB (71315456 Bytes)
[root@bab281a9dc09 /]# exit
```



