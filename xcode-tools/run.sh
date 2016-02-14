#!/bin/bash
#
# Run gm2 in docker

#   The docker-machine environment must already be set
#
# Arguments
#   $1 = Name of the c67cvmfs container
#   $2 = Directory to run in
#   $@ = More Arguments
#
#   The current directory should be the build area; there needs
#   to be a gm2.env file there

container=$1
dir=$2
shift ; shift

# Execute in the container (use bash -l to load .bashrc)
docker exec $container bash -c -l "cd $PWD ; restore_gm2 ;  cd $dir ; gm2 $@"
