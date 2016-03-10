IMAGE ?= c67cvmfsnfsclient
NAME ?= cvmfs_nfs_client

ARGS_PRIVILEGED := --privileged

do-nfs-client :
	-$(eval NFS_SERVER_IP := $(shell docker inspect --format '{{.NetworkSettings.IPAddress}}' cvmfs_nfs_server))
	$(eval EXTRA_DOCKER_RUN_FLAGS += -e NFS_SERVER_IP=$(NFS_SERVER_IP))


shell : | do-bash-history do-nfs-client do-docker-run do-post-run

include ../Makefile
