IMAGE ?= c67base
NAME ?= c67base

# Set the build arguments (MYUID and MYGID)
MYUID := $(shell id -u)
MYGID := $(shell id -g)
BUILD_ARGS := --build-arg=MYUID=$(MYUID) --build-arg=MYGID=$(MYGID)

include ../Makefile
