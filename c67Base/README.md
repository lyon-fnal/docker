# c67Base

Image name: squark/c67base

Centos 6.7 - Base 

Creates an image from centos 6.7 that installs enough packages that you can  build and run gm2 software, so long as there's a gm2 ups repository (release) somewhere on your host that the container can access. That is you must run the container with the `--volume (-v)` option pointing to the path to the gm2 ups repository. 

The intended use case is to mount the ups repository on the host system via CVMFS to `/cvmfs/gm2.opensciencegrid.org` and make that accessible to the container. 

If you are using a Mac, you must prepare the docker 
virtual machine to make your host's CVMFS visible. Here's how to do this with a standard Mac docker installation (launch "Docker Quickstart Terminal")...

```bash
# Add /cvmfs/gm2.opensciencegrid.org to the Virtual Box VM as
#    the 'gm2cvmfs' shared folder. 
#    You only need to do this once, unless you delete the VM itself
docker-machine stop default
VBoxManage sharedfolder add default --name "gm2cvmfs" --hostpath /cvmfs/gm2.opensciencegrid.org --automount
docker-machine start default

# Now we must mount the volume within the VM. Despite the --automount flag
#   this task doesn't seem to happen by itself.
#   You will need to do this step EVERY TIME the docker-machine VM
#   restarts (e.g. you reboot your Mac)
docker-machine ssh default
  sudo mkdir -p /cvmfs/gm2.opensciencegrid.org
  sudo mount -t vboxsf gm2cvmfs /cvmfs/gm2.opensciencegrid.org
  ls /cvmfs/gm2.opensciencegrid.org   # verify 
  exit
```

To build this docker image, assuming you are following the git repository, do

```bash
# Create squark/c67base
docker build -t squark/$(basename $PWD | tr A-Z a-z) .
```

The size should be approximately 536 MB. 

To run a container with this image, do

```bash
docker run -t -i \
         -v /cvmfs/gm2.opensciencegrid.org:/cvmfs/gm2.opensciencegrid.org \
         squark/c67base
```

Add other `-v` options to make more data volumes visible. For example, on your Mac add `-v /Users:/Users` (the `/Users` shared folder is added to your docker machine VM by the docker installation).

Within this container, you can build and run gm2 code. 

