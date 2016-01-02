FROM centos:6.7
MAINTAINER Adam Lyon

RUN yum install -y perl expat-devel glibc-devel gdb freetype-devel libXpm-devel libXmu-devel mesa-libGL-devel mesa-libGLU-devel

ENV UPS_OVERRIDE "-H Linux64bit+2.6-2.12"
ENV UPS_FLAVOR_OVERRIDE $UPS_OVERRIDE
