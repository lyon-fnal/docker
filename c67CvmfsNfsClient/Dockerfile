FROM lyonfnal/c67base
MAINTAINER Adam Lyon <lyon@fnal.gov>

USER root

RUN yum -y install nfs-utils nfs-utils-lib && \
    yum clean all

COPY startCvmfsNfsClient.sh /usr/local/bin

USER me

# Mount CVMFS from NFS on entry
# (See http://www.markbetz.net/2014/03/17/docker-run-startup-scripts-then-exit-to-a-shell/)
# The -C means to prevent output redirection from overwriting files
CMD bash -C "/usr/local/bin/startCvmfsNfsClient.sh";"bash"
