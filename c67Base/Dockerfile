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
          tar zip xz bzip2 patch \
          wget emacs which sudo strace && \
    yum clean all

# Get our kerberos
COPY slf.repo /etc/yum.repos.d/slf.repo
RUN wget http://ftp.scientificlinux.org/linux/fermi/slf6.7/x86_64/os/RPM-GPG-KEY-sl && \
    rpm --import RPM-GPG-KEY-sl && \
    rm -f RPM-GPG-KEY-sl && \
    yum install -y krb5-fermi-getcert --enablerepo=slf && \
    yum clean all

# Install the Fermilab krb5.conf
RUN wget http://computing.fnal.gov/authentication/krb5conf/Linux/krb5.conf -O /etc/krb5.conf

# Install the OSG client
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm && \
    yum install -y yum-plugin-priorities && \
    rpm -Uvh https://repo.grid.iu.edu/osg/3.3/osg-3.3-el6-release-latest.rpm && \
    yum install -y osg-wn-client && \
    yum clean all

# UPS gets the flavor of the machine running docker instead of the docker container.
#   We can force the correct flavor with UPS_OVERRIDE
#   Note that mrb changes UPS_OVERRIDE (adding the -B). The mrb code has been updated
#   to copy UPS_FLAVOR_OVERRIDE into UPS_OVERRIDE when necessary.
ENV UPS_FLAVOR_OVERRIDE "-H Linux64bit+2.6-2.12"
ENV UPS_OVERRIDE $UPS_FLAVOR_OVERRIDE

# Create a gm2 user (UID and GID should match the Mac user), add to suoders, and switch to it
ENV USERNAME gm2

# Pass in the user ID :and the group ID to use
ARG MYUID
ENV MYUID ${MYUID:-1000}
ARG MYGID
ENV MYGID ${MYGID:-100}

RUN useradd -u $MYUID -g $MYGID -ms /bin/bash $USERNAME && \
      echo "$USERNAME ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME
