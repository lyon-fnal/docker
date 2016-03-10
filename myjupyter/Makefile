# Make commands for myjupyter

.PHONY: notebook build

DATA_DOCUMENTS ?= /Users/lyon/dataAnalysisPlatform/Documents
DOCKER_PORT ?= 8888
MYUID := $(shell id -u)
IMAGE ?= myjupyter
NAME ?= jupyter_notebook
DM_DRIVER := $(shell docker-machine inspect --format='{{.DriverName}}' ${DOCKER_MACHINE_NAME})
DM_IP := $(shell docker-machine ip ${DOCKER_MACHINE_NAME})

# If we're running the xhyve VM, then we need to set the UID to the host's UID
ARGS_ID :=
ifeq ($(DM_DRIVER),xhyve)
ARGS_UID := --user root -e NB_UID=$(MYUID)
endif

do-notebook :
	-docker run -d -p $(DOCKER_PORT):$(DOCKER_PORT) \
 					$(ARGS_UID) \
				  -v $(DATA_DOCUMENTS):/home/jovyan/work \
					--name $(NAME) \
					$(IMAGE) start-notebook.sh
	@echo "Connect to $(DM_IP):$(DOCKER_PORT)"
	@echo "Run 'make clean' when done"

do-shell :
	-docker run -it --rm -p $(DOCKER_PORT):$(DOCKER_PORT) \
		-v $(DATA_DOCUMENTS):/home/jovyan/work \
		--name jupyter-shell \
		$(IMAGE) /bin/bash

do-build :
	-docker build -t $(IMAGE) .

do-clean:
	-docker stop $(NAME)
	-docker rm $(NAME)

#-------

notebook : do-notebook

shell : do-shell

build : do-build

clean : do-clean
