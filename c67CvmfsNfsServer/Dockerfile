FROM c67cvmfs
MAINTAINER Adam Lyon <lyon@fnal.gov>

USER root

RUN yum -y install nfs-utils nfs-utils-lib && \
    yum clean all

COPY startCvmfsNfsServer.sh /usr/local/bin

EXPOSE 111 2049

USER gm2

# Mount CVMFS on entry and start the server
# (See http://www.markbetz.net/2014/03/17/docker-run-startup-scripts-then-exit-to-a-shell/)
# The -C means to prevent output redirection from overwriting files
CMD bash -C "/usr/local/bin/startCvmfsNfsServer.sh";"bash"
