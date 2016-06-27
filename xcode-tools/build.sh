#!/bin/bash
#
#  Build gm2 code in a docker container
#
#   The docker-machine environment must already be set
#
# Arguments
#   $1 = Name of the container
#
#   The current directory should be the build area; there needs
#   to be a gm2.env file there

# Execute in the container (use bash -l to load .bashrc)

# Get location of this script, because gm2_fcns.sh is there too
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Execute the build in the container
# Note the use of "pipefail" -- see http://stackoverflow.com/questions/1221833/bash-pipe-output-and-capture-exit-status
#   That allows the exit status of ninja to trump the likely aways sucessful sed
docker exec $1 bash -c -l \
  "source $DIR/gm2_fcns.sh ; cd $MRB_BUILDDIR ; restore_gm2 ; ( set -o pipefail ; ninja 2>&1 | sed \"s#${MRB_SOURCE}#${PWD}#g\" ) "
