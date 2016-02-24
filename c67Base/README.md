# c67Base

Image name: c67base

Centos 6.7 - Base

Creates an image from Centos 6.7 that installs enough system packages that you can build and run gm2 software,
assuming you have access to a release.

In general, you wouldn't use this image directly. Instead, you would use c67cvmfs of c67allinea as those
images give you access to the g-2 CVMFS repository.

The `Makefile` in this directory does not add any features beyond those in `../Makefile`. It does set the user ID and group ID for the build.
