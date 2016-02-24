	# Makefile to run docker stuff
#  This is a generic Makefile to run our different images
#


.PHONY: help bkg x11 shell

LOCAL_VOLUME ?= /Users
DOCKER_HISTORY_FILE ?= $(PWD)/docker_bash_history
NAME ?= gm2
DOCKER_MACHINE_NAME ?= xhyve
BUILD_ARGS ?=

ARGS_RM := --rm
ARGS_BKG :=
ARGS_DISPLAY :=
ARGS_PRIVILEGED :=
ARGS_CVMFS :=


# ----------------------

help-top:
	@echo 'Host commands:'
	@echo ' '
	@echo ' OSX/Windows: You may need to run '
	@echo  '       eval $$(docker-machine env <VM-name>)'
	@echo  '  to connect to your docker VM'
	@echo ' '
	@echo ' make build  -- build the image in the current directory to name IMAGE'
	@echo ' make shell  -- Run container with shell (if image supports it)'
	@echo '                with LOCAL_VOLUME and BASH_HISTORY_FILE'
	@echo ' make clean-bkg -- Clean up the bkg container'
	@echo ' '
	@echo ' make build-all -- Build all of the images (must be run from docker-gm2 top level dir)'
	@echo ' '
	@echo ' make create-machine-xhyve -- Build an xhyve VM on OSX (see https://goo.gl/q4WTCd)'
	@echo ' make create-machine-vbox  -- Create a virtualbox VM on OSX'
	@echo ' make fix-clock-skew-xhyve -- Resync the clock on the xhyve VM - fixes clock skew errors'
	@echo
	@echo '   Options in front of shell...'
	@echo '      make x11 shell   -- run with X11'
	@echo '      make bkg shell   -- run in background'

# ---- Internal Targets ----
check-image-is-set:
	@if [ -z $(IMAGE) ] ; then \
		echo 'IMAGE is not set'; \
		exit 1 ; \
	fi

do-build: check-image-is-set
	docker build $(BUILD_ARGS) -t $(IMAGE) .

do-bash-history:
	# We need to create the history file, else docker run makes it a directory
	touch $(DOCKER_HISTORY_FILE)

do-bkg:
	$(eval DID_BKG := yes)
	$(eval ARGS_BKG := -d )
	$(eval ARGS_RM := )

do-x11:
	$(eval DID_X11 := yes)
	$(eval BRIDGE100IP := $(shell ifconfig bridge100  | grep inet | cut -d' ' -f 2))
	$(eval ARGS_DISPLAY := -e DISPLAY=$(BRIDGE100IP):0)
	$(eval DOCKER_VM_IP := $(shell docker-machine ip $(DOCKER_MACHINE_NAME) ))
	-killall socat
	open -a Xquartz
	socat TCP-LISTEN:6000,reuseaddr,fork,range=$(DOCKER_VM_IP):255.255.255.0 UNIX-CLIENT:\"$$DISPLAY\" &
	# Must set the range option, else our port 6000 is open to everybody!

do-docker-run: check-image-is-set
	# Run the container
	-docker run $(ARGS_RM) $(ARGS_BKG) -ti \
	  --name=$(NAME) \
		$(ARGS_DISPLAY) $(ARGS_PRIVILEGED) \
		-v $(DOCKER_HISTORY_FILE):/home/gm2/.bash_history \
		-v $(LOCAL_VOLUME):$(LOCAL_VOLUME) \
		$(EXTRA_DOCKER_RUN_FLAGS) \
		$(IMAGE) \
		$(CMD)

do-post-run:
	@if [ -n "$(DID_BKG)" ] ; then \
		echo 'When you finish with your container, run "make clean"'; \
	else \
		if [ -n "$(DID_X11)" ] ; then \
			echo 'Killing socat'; \
			killall socat; \
		fi \
	fi

do-clean-recent-container:
	docker stop -t 0 `docker ps -lq`
	docker rm `docker ps -lq`

do-kill-socat:
	-killall socat

# ----- External Targets -----

help: help-top

build: do-build

x11: do-x11

bkg: do-bkg

shell: | do-bash-history do-docker-run do-post-run

clean: | do-clean-recent-container do-kill-socat

# Build all of the images
build-all:
	$(MAKE) -C c67Base build
	$(MAKE) -C c67Cvmfs build
	$(MAKE) -C c67Allinea build
	$(MAKE) -C c67Spack build

# Create the Xhyve VM (for OSX with xhyve installed)
create-machine-xhyve :
	docker-machine create --driver xhyve \
		--xhyve-experimental-nfs-share \
		--xhyve-cpu-count=8 \
		--xhyve-memory-size=8192 \
		xhyve

# Create the virtualbox machine
create-machine-vbox :
	docker-machine create --driver virtualbox \
	 	--virtualbox-cpu-count=8 \
		--virtualbox-memory=8192 \
		vbox

# Fix clock-skew errors
fix-clock-skew-xhyve :
	docker-machine ssh xhyve "sudo date -u -D %s --set $(shell date -u +%s)"

# -------------------------------
