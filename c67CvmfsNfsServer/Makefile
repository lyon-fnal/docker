IMAGE ?= lyonfnal/c67cvmfsnfsserver
NAME ?= cvmfs_nfs_server

ARGS_PRIVILEGED := --privileged

help-cvmfs-nfs-server:
	@echo "-----------"
	@echo "   Additonal option in front of shell from CVMFS"
	@echo "      make bkg shell   -- Run cvmfs NFS server"

do-mac-cvmfs:
	sudo mount -t nfs -o resvport $$(docker-machine ip $(DOCKER_MACHINE_NAME)):/cvmfs/gm2.opensciencegrid.org /cvmfs/gm2.opensciencegrid.org
	sudo mount -t nfs -o resvport $$(docker-machine ip $(DOCKER_MACHINE_NAME)):/cvmfs/fermilab.opensciencegrid.org /cvmfs/fermilab.opensciencegrid.org

cvmfs-nfs-server: do-cvmfs

help: |help-top help-cvmfs-nfs-server

# Ports to map to allow host to mount cvmfs
#EXTRA_DOCKER_RUN_FLAGS += -p 111:111 -p 2049:2049 -p 892:892 -p 32769:32769/udp -p 32803:32803 \
#                          -p 111:111/udp -p 2049:2049/udp -p 892:892/udp


#EXTRA_DOCKER_RUN_FLAGS += --net=host

#EXTRA_DOCKER_RUN_FLAGS += --restart=unless-stopped

#EXTRA_DOCKER_RUN_INSTRUCTIONS += "You can mount cvmfs on your host with (Mac) \n" \
                                 #"sudo mount -t nfs -o resvport $$(docker-machine ip $(DOCKER_MACHINE_NAME)):/cvmfs/gm2.opensciencegrid.org /cvmfs/gm2.opensciencegrid.org\n" \
																 #"sudo mount -t nfs -o resvport $$(docker-machine ip $(DOCKER_MACHINE_NAME)):/cvmfs/fermilab.opensciencegrid.org /cvmfs/fermilab.opensciencegrid.org"

include ../c67Cvmfs/Makefile
