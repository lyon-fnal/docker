IMAGE ?= c67cvmfsnfsserver
NAME ?= cvmfs_nfs_server

ARGS_PRIVILEGED := --privileged

help-cvmfs-nfs-server:
	@echo "-----------"
	@echo "   Additonal option in front of shell from CVMFS"
	@echo "      make bkg cvmfs-nfs-server shell   -- Run cvmfs NFS server"


cvmfs-nfs-server: do-cvmfs

help: |help-top help-cvmfs-nfs-server

EXTRA_DOCKER_RUN_FLAGS += -p 2049:2049 -p 111:111 --restart=unless-stopped

include ../c67Cvmfs/Makefile
