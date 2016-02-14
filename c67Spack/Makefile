IMAGE ?= c67spack
NAME ?= c67spack

MY_SPACK_AREA ?= /Users/$(USER)/Development/spack

DOCKER_HISTORY_FILE ?= $(MY_SPACK_AREA)/docker_bash_history

EXTRA_DOCKER_RUN_FLAGS += -v $(MY_SPACK_AREA)/dotspackconfig:/home/gm2/.spackconfig \
                          -v $(MY_SPACK_AREA)/dotspack:/home/gm2/.spack \
    		          -e MY_SPACK_AREA=$(MY_SPACK_AREA) \
	  		  -e SPACK_ROOT=$(MY_SPACK_AREA)/spack

CMD=/bin/bash -l

# Outboard tmp (put tmp outside of the VM to avoid blowing up the VM disk)
outboard-tmp:
	$(eval EXTRA_DOCKER_RUN_FLAGS += -v $(MY_SPACK_AREA)/tmp:/tmp)
	-mkdir ${MY_SPACK_AREA}/tmp

include ../Makefile
