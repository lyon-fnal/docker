IMAGE ?= lyonfnal/c67igprof
NAME ?= c67igprof

# We need to add the license directory
# Your license file is specified by LICENSE_FILE.
# It will be mapped to /opt/allinea/forge/licenses

help-igprof:
	@echo "-----------"
	@echo "      make cvmfs x11 shell   -- Make igprof available "

help: help-top help-cvmfs help-igprof

EXTRA_DOCKER_RUN_FLAGS += -p 8900:8900 -p 8901:8901 -p 8902:8902

include ../c67CvmfsNfsClient/Makefile
