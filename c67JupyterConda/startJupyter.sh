#!/usr/bin/env bash
#
# Start jupyter

/usr/local/bin/startCvmfsNfsClient.sh 
source /opt/miniconda/bin/activate /opt/miniconda
jupyter notebook --ip '*' --no-browser
