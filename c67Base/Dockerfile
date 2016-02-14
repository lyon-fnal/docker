FROM centos:6.7
MAINTAINER Adam Lyon <lyon@fnal.gov>

# Install packages (comments below refer to the lines in yum install)
#    Basic packages to run g-2 code
#    X11 and OpenGL to run Geant and Root
#    Additional packages for Root
#    Nice things to have
RUN yum update -y && \
    yum install -y \
          perl expat-devel glibc-devel gdb git \
          freetype-devel libXpm-devel libXmu-devel mesa-libGL-devel mesa-libGLU-devel \
          libjpeg libpng \
          wget sudo krb5-workstation && \
    yum clean all

# Install the Fermilab krb5.conf
RUN wget http://computing.fnal.gov/authentication/krb5conf/Linux/krb5.conf -O /etc/krb5.conf

# UPS gets the flavor of the machine running docker instead of the docker container.
#   We can force the correct flavor with UPS_OVERRIDE
#   Note that mrb changes UPS_OVERRIDE (adding the -B). The mrb code has been updated
#   to copy UPS_FLAVOR_OVERRIDE into UPS_OVERRIDE when necessary.
ENV UPS_FLAVOR_OVERRIDE "-H Linux64bit+2.6-2.12"
ENV UPS_OVERRIDE $UPS_FLAVOR_OVERRIDE

# Create a gm2 user (UID and GID should match the Mac user), add to suoders, and switch to it
ENV USERNAME gm2
ENV MYUID 502
ENV MYGID 20

RUN useradd -u $MYUID -g $MYGID -ms /bin/bash $USERNAME && \
      echo "$USERNAME ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME
