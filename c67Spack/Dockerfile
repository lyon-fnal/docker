FROM lyonfnal/c67base

MAINTAINER lyon@fnal.gov

USER root

# Bootstrap stuff for spack
#  perl-CPAN... for new git
#  epel-release, tcl, lua-devel... for lmod
RUN yum -y update && \
    yum -y install gcc gcc-gfortran gcc-c++ m4 bison svn \
                   perl-CPAN gettext curl-devel && \
    yum -y install epel-release && \
    yum -y install tcl lua-devel lua-filesystem lua-posix && \
    yum -y install libXft-devel && \
    yum clean all

WORKDIR /home/root

# Build the latest git (the Centos6 version is really oldy
RUN wget https://www.kernel.org/pub/software/scm/git/git-2.7.1.tar.xz && \
    tar xvf git-2.7.1.tar.xz && \
    cd git-2.7.1 && \
    ./configure --prefix=/usr/local && \
    make install && \
    cd .. && \
    rm -rf git-2.7.1  git-2.7.1.tar.xz

# Build lmod
RUN wget -O Lmod-6.1.tar.bz2 http://sourceforge.net/projects/lmod/files/Lmod-6.1.tar.bz2/download && \
    tar xvjf Lmod-6.1.tar.bz2 && \
    cd Lmod-6.1 && \
    ./configure --prefix=/usr/local && \
    make install && \
    rm -rf Lmod-6.1 Lmod-6.1.tar.bz2

USER gm2
WORKDIR /home/gm2

# Assume that spack is in an attached volume

COPY bash_profile .bash_profile

# You must set SPACK_ROOT in your container startup
