#!/bin/bash
#
#  Build gm2 code in a docker container
#
#   The docker-machine environment must already be set
#
# Arguments
#   $1 = Name of the c67cvmfs container
#
#   The current directory should be the build area; there needs
#   to be a gm2.env file there

# Execute in the container (use bash -l to load .bashrc)
docker exec $1 bash -c -l "cd $PWD ; restore_gm2 ; ninja"
