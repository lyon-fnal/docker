FROM c67base
MAINTAINER Adam Lyon <lyon@fnal.gov>

# Following instructions from https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallCvmfs

USER root

RUN yum -y install yum-plugin-priorities &&  \
    rpm -Uvh https://repo.grid.iu.edu/osg/3.3/osg-3.3-el6-release-latest.rpm && \
    yum -y install osg-oasis && \
    yum clean all

RUN echo "user_allow_other" > /etc/fuse.conf

COPY osg_cvmfs_default.local /etc/cvmfs/default.local
RUN mkdir /cvmfs/gm2.opensciencegrid.org
RUN mkdir /cvmfs/fermilab.opensciencegrid.org
COPY startCvmfs.sh /usr/local/bin

USER gm2

# Mount CVMFS on entry
# (See http://www.markbetz.net/2014/03/17/docker-run-startup-scripts-then-exit-to-a-shell/)
# The -C means to prevent output redirection from overwriting files
CMD bash -C "/usr/local/bin/startCvmfs.sh";"bash"
