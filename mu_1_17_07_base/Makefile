IMAGE ?= lyonfnal/mu_1_17_07_base
NAME ?= mu_1_17_07_base

# Set the build arguments (MYUID and MYGID)
MYUID := $(shell id -u)
MYGID := $(shell id -g)
DM_DRIVER := $(shell docker-machine inspect --format='{{.DriverName}}' ${DOCKER_MACHINE_NAME})

# If we're using the xhyve VM, then we need to set the UID/GID to the same as the host
BUILD_ARGS :=
ifeq ($(DM_DRIVER),xhyve)
BUILD_ARGS := --build-arg=MYUID=$(MYUID) --build-arg=MYGID=$(MYGID)
endif

ARGS_PRIVILEGED := --privileged

NFS_SERVER_IP := $(shell docker inspect --format '{{.NetworkSettings.IPAddress}}' cvmfs_nfs_server)

ifeq ($(NFS_SERVER_IP),)
NFS_SERVER_IP := localhost
EXTRA_DOCKER_FLAGS := --net=host
endif

EXTRA_DOCKER_RUN_FLAGS += -e NFS_SERVER_IP=$(NFS_SERVER_IP)

shell : | do-bash-history do-docker-run do-post-run

include ../Makefile
