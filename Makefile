# Makefile to run docker stuff
#  This is a generic Makefile to run our different images
#

BUILD_ARGS ?=

# ---- Internal Targets ----
check-image-is-set:
	@if [ -z $(IMAGE) ] ; then \
		echo 'IMAGE is not set'; \
		exit 1 ; \
	fi

do-build: check-image-is-set
	docker build $(BUILD_ARGS) -t $(IMAGE):latest -t $(IMAGE):$(shell git rev-parse --short HEAD) .

push: check-image-is-set
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(shell git rev-parse --short HEAD)

build: do-build

# Build all of the images
build-all:
	make -C c67Base build
	make -C c67Cvmfs build
	make -C c67CvmfsNfsServer build
	make -C c67CvmfsNfsClient build
	make -C c67Igprof build
	make -C c67WebDav build
#	make -C c67Allinea build
#	make -C c67Spack build

push-all:
	make -C c67Base push
	make -C c67Cvmfs push
	make -C c67CvmfsNfsServer push
	make -C c67CvmfsNfsClient push
	make -C c67Igprof push
	make -C c67WebDav push

# Create the Xhyve VM (for OSX with xhyve installed)
create-machine-xhyve :
	docker-machine create --driver xhyve \
		--xhyve-experimental-nfs-share \
		--xhyve-cpu-count=8 \
		--xhyve-memory-size=8192 \
		$(NEW_DOCKER_MACHINE_NAME)

# Create the virtualbox machinecreate-machine-vbox :
# Note that I used to do --virtualbox-host-dns-resolver but that breaks reverse DNS
#   needed by kx509 and xrootd
create-machine-vbox :
	docker-machine create --driver virtualbox \
	 	--virtualbox-cpu-count=4 \
		--virtualbox-memory=8192 \
		--virtualbox-disk-size="50000" \
		$(NEW_DOCKER_MACHINE_NAME)
	# Do not stop the VM on low battery warning
	VBoxManage setextradata "$(NEW_DOCKER_MACHINE_NAME)" "VBoxInternal2/SavestateOnBatteryLow" 0

# Create the virtualbox machine
create-machine-vbox-vdi : create-machine-vbox
	# We're going to make some adjustments to the VM, so power down
	docker-machine stop "$(NEW_DOCKER_MACHINE_NAME)"
	# Turn on DNS proxying so we don't lose DNS when the host changes networks
	VBoxManage modifyvm "$(NEW_DOCKER_MACHINE_NAME)" --natdnsproxy1 on
	# Convert the vmdk disk to vdi so we can shrink it later
	# Note - since cd happens in a subshell, we need to && things
	cd $$(docker-machine inspect --format '{{.HostOptions.AuthOptions.StorePath}}' $(NEW_DOCKER_MACHINE_NAME)) && VBoxManage clonehd --format vdi disk.vmdk disk.vdi
	# Remove and delete the vmdk disk
	VBoxManage storageattach "$(NEW_DOCKER_MACHINE_NAME)" --storagectl SATA --port 1 --medium none
	VBoxManage closemedium $$(docker-machine inspect --format '{{.HostOptions.AuthOptions.StorePath}}' $(NEW_DOCKER_MACHINE_NAME))/disk.vmdk --delete
	# Add the vdi disk to the VM
	VBoxManage storageattach "$(NEW_DOCKER_MACHINE_NAME)" --storagectl SATA --port 1 --type hdd --nonrotational on \
	           --medium $$(docker-machine inspect --format '{{.HostOptions.AuthOptions.StorePath}}' $(NEW_DOCKER_MACHINE_NAME))/disk.vdi
	# Restart the VM
	docker-machine start "$(NEW_DOCKER_MACHINE_NAME)"
	# Apparently we need to recreate the certificates
	docker-machine regenerate-certs -f "$(NEW_DOCKER_MACHINE_NAME)"
	docker-machine env "$(NEW_DOCKER_MACHINE_NAME)"

# Shrink a virtualbox disk
shrink-disk-vbox:
	# Make a big empty file - may take a long time (it will end on an error)
	docker-machine ssh $(DOCKER_MACHINE_NAME) "cd /mnt/sda1 && sudo dd if=/dev/zero of=bigemptyfile bs=4096k || sudo rm -f bigemptyfile"
	docker-machine stop $(DOCKER_MACHINE_NAME)
	ls -lh $$(docker-machine inspect --format '{{.HostOptions.AuthOptions.StorePath}}' $(DOCKER_MACHINE_NAME))/disk.vdi
	VBoxManage modifyhd $$(docker-machine inspect --format '{{.HostOptions.AuthOptions.StorePath}}' $(DOCKER_MACHINE_NAME))/disk.vdi --compact
	ls -lh $$(docker-machine inspect --format '{{.HostOptions.AuthOptions.StorePath}}' $(DOCKER_MACHINE_NAME))/disk.vdi
	docker-machine start $(DOCKER_MACHINE_NAME)

# Fix clock-skew errors
#fix-clock-skew :
#	docker-machine ssh $(DOCKER_MACHINE_NAME) "sudo date -u -D %s --set $(shell date -u +%s)"

fix-clock-skew :
	docker run --rm --privileged centos:6.7  date -s "`date`"

check-archive-is-set:
	@if [ -z $(ARCHIVE) ] ; then \
		echo 'ARCHIVE is not set - set it to the name of the container to archive'; \
		exit 1 ; \
	fi

archive: check-archive-is-set
	@$(eval ARCHIVE_VOLS := /container/description /container/log)
	@$(eval ARCHIVE_VOLS += $(shell docker inspect --format '{{range .Mounts}}{{if eq .Driver "local" }}{{ .Destination }} {{end}}{{end}}' $(ARCHIVE) ))
	@docker logs -t $(ARCHIVE) > archive_log
	@echo $(ARCHIVE) > archive_description
	@echo "\nWrite Description Here\n\n" >> archive_description
	@docker inspect $(ARCHIVE) >> archive_description
	@$(EDITOR) archive_description
	@docker run --rm --volumes-from $(ARCHIVE) -v $(PWD):/backup \
	                -v $(PWD)/archive_description:/container/description \
									-v $(PWD)/archive_log:/container/log \
									lyonfnal/c67base \
									tar cvzf /backup/$(ARCHIVE).tgz $(ARCHIVE_VOLS)
	@rm -f archive_log archive_description
	@echo WROTE TO $(ARCHIVE).tgz
