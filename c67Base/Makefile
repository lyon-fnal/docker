IMAGE ?= c67base
NAME ?= c67base

# Set the build arguments (MYUID and MYGID)
MYUID := $(shell id -u)
MYGID := $(shell id -g)
DM_DRIVER := $(shell docker-machine inspect --format='{{.DriverName}}' ${DOCKER_MACHINE_NAME})

# If we're using the xhyve VM, then we need to set the UID/GID to the same as the host
BUILD_ARGS :=
ifeq ($(DM_DRIVER),xhyve)
BUILD_ARGS := --build-arg=MYUID=$(MYUID) --build-arg=MYGID=$(MYGID)
endif

include ../Makefile
