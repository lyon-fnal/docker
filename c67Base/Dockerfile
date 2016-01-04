FROM centos:6.7
MAINTAINER Adam Lyon <lyon@fnal.gov>

RUN yum install -y perl expat-devel glibc-devel gdb freetype-devel libXpm-devel libXmu-devel mesa-libGL-devel mesa-libGLU-devel

# UPS gets the flavor of the machine running docker instead of the docker container.
#   We can force the correct flavor with UPS_OVERRIDE
#   Note that mrb changes UPS_OVERRIDE (adding the -B). The mrb code has been updated
#   to copy UPS_FLAVOR_OVERRIDE into UPS_OVERRIDE when necessary.
ENV UPS_FLAVOR_OVERRIDE "-H Linux64bit+2.6-2.12"
ENV UPS_OVERRIDE $UPS_FLAVOR_OVERRIDE
