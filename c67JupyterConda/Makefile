IMAGE ?= lyonfnal/c67jupyterconda
NAME ?= c67jupyterconda

ARGS_PRIVILEGED := --privileged

NFS_SERVER_IP := $(shell docker inspect --format '{{.NetworkSettings.IPAddress}}' cvmfs_nfs_server)

ifeq ($(NFS_SERVER_IP),)
NFS_SERVER_IP := localhost
EXTRA_DOCKER_FLAGS := --net=host
endif

EXTRA_DOCKER_RUN_FLAGS += -e NFS_SERVER_IP=$(NFS_SERVER_IP) -p 8888:8888

jupyter: | do-jupyter do-docker-run

do-jupyter:
	$(eval INTERACTIVE :=  -dt)
	$(eval CMD := /usr/local/bin/tini -- /usr/local/bin/startJupyter.sh)

jupyter-stop:
	docker stop $(NAME)
	docker rm $(NAME)

include ../Makefile
