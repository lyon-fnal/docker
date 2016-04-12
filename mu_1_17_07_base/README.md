# `lyofnal/mu-devel-v1_17_07-s30-e9-prof`

This directory has a `Dockerfile` for an image that extends `fnalart/mu-devel-v1_17_07-s30-e9-prof`, which embodies the `mu` distribution of the Fermilab art suite. 

This image has,

* The `mu` release `v1_17_07` profile build in the `/products` directory. 
* Enough of X11 to pop windows
* Convenience utilities like perl, expat, time, git, tar, zip, bzip2, wget, emacs, which, and strace
* Fermilab kerberos (so `kinit` works)
* OSG client so you can get a `Kerberos Certificate`. 
* Sets up the Fermilab SLF6 yum repository
* Sets `UPS_OVERRIDE` to make the image look like SLF6 to UPS
* Mounts CVMFS from NFS (though CVMFS is not needed to run art, as that is local to the image in `/products`). The `cvmfs_nfs_server` container must be running.
* All work is done in the `gm2` account (you can `sudo` to root if necessary)

To setup up `art v1_17_07` do,

On your host

```bash
cd /path/to/docker-gm2
make mu-shell
```

In the container

```bash
source /products/setup
setup art v1_17_07 -q prof:e9
```


