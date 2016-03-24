#!/bin/bash
#
# Run gm2 in docker

#   The docker-machine environment must already be set
#
# Arguments
#   $1 = Name of the container
#   $2 = Directory to run in
#   $@ = More Arguments
#
#   The current directory should be the build area; there needs
#   to be a gm2.env file there

container=$1
rundir=$2
shift ; shift

# Execute in the container (use bash -l to load .bashrc)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker exec $container bash -c -l "source $DIR/gm2_fcns.sh ; cd $PWD ; restore_gm2 ;  cd $rundir ; gm2 $@"
