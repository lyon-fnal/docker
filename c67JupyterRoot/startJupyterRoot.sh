#!/usr/bin/env bash
#
# Start jupyter

# Add /usr/krb5/bin to PATH
export PATH=/usr/krb5/bin:$PATH

# Mount CVMFS
/usr/local/bin/startCvmfsNfsClient.sh

# Setup IFDH
source /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setup
setup fife_utils v3_0_1
export SAM_EXPERIMENT=GM2

# Setup root
source /opt/products/setup
setup root v6_06_02 -q e9:prof

# Add extra python
# $PYTHON_DATA_PLATFORM_2710 is set by ENV in the Dockerfile
export PATH=$PYTHON_DATA_PLATFORM_2710/bin:$PATH
export LD_LIBRARY_PATH=$PYTHON_DATA_PLATFORM_2710/lib:$LD_LIBRARY_PATH
export PYTHONPATH=$PYTHON_DATA_PLATFORM_2710/lib/python2.7/site-packages:$PYTHONPATH

jupyter notebook --port 8889 --ip '*' --no-browser
