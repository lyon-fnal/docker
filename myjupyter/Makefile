IMAGE ?= lyonfnal/myjupyter
NAME ?= myjupyter

ARGS_PRIVILEGED := --privileged

NFS_SERVER_IP := $(shell docker inspect --format '{{.NetworkSettings.IPAddress}}' cvmfs_nfs_server)

ifeq ($(NFS_SERVER_IP),)
NFS_SERVER_IP := localhost
EXTRA_DOCKER_FLAGS := --net=host
endif

EXTRA_DOCKER_RUN_FLAGS += -e NFS_SERVER_IP=$(NFS_SERVER_IP) -p 8888:8888

shell : | do-bash-history do-docker-run do-post-run

include ../Makefile
