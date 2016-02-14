IMAGE ?= c67allinea
NAME ?= c67allinea

# We need to add the license directory
# Your license file is specified by LICENSE_FILE.
# It will be mapped to /opt/allinea/forge/licenses

help-allinea:
	@echo "-----------"
	@echo "   Additonal option in front of shell from Allinea"
	@echo "      LICENSE_FILE=my_license_file make allinea cvmfs x11 shell   -- Make allinea available "

check-license-file:
	@if [ -z $(LICENSE_FILE) ] ; then \
		echo 'LICENSE_FILE is not set'; \
		exit 1 ; \
	fi
	@if [ ! -f $(LICENSE_FILE) ] ; then \
		echo "License file $(LICENSE_FILE) is not a readable file" ; \
		exit 1 ; \
	fi

do-allinea: check-license-file
	$(eval LICENSE_FILE_ABS := $(abspath $(LICENSE_FILE)))
	$(eval EXTRA_DOCKER_RUN_FLAGS += -v $(LICENSE_FILE_ABS):/opt/allinea/forge/licences/Licence)

allinea: do-allinea

help: help-top help-cvmfs help-allinea

include ../c67Cvmfs/Makefile
