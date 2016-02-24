IMAGE ?= c67spack
NAME ?= c67spack

MY_SPACK_AREA ?= /Users/$(USER)/Development/spack
SPACK_ROOT    ?= $(MY_SPACK_AREA)/spack

DOCKER_HISTORY_FILE ?= $(MY_SPACK_AREA)/docker_bash_history

EXTRA_DOCKER_RUN_FLAGS += -v $(MY_SPACK_AREA)/dotspackconfig:/home/gm2/.spackconfig \
                          -v $(MY_SPACK_AREA)/dotspack:/home/gm2/.spack \
    		          -e MY_SPACK_AREA=$(MY_SPACK_AREA) \
	  		  -e SPACK_ROOT=$(SPACK_ROOT)

CMD=/bin/bash -l

# Outboard tmp (put tmp outside of the VM to avoid blowing up the VM disk)

help-spack:
	@echo '---------'
	@echo '  For c67spack...'
	@echo '  make shell -- Run a shell with $$MY_SPACK_AREA set to $(MY_SPACK_AREA) ,'
	@echo '                   $$SPACK_ROOT set to $(SPACK_ROOT),'
	@echo '                   $$MY_SPACK_AREA/dotspack mirrored as ~/.spack ,'
	@echo '                   $$MY_SPACK_AREA/dotspackconfig mirrored as ~/.spackconfig'
	@echo '   Do "make outboard-tmp shell" to set $$MY_SPACK_AREA/tmp as /tmp'


help: help-top help-spack

outboard-tmp:
	$(eval EXTRA_DOCKER_RUN_FLAGS += -v $(MY_SPACK_AREA)/tmp:/tmp)
	-mkdir ${MY_SPACK_AREA}/tmp

include ../Makefile
