FROM squark/c67base
MAINTAINER Adam Lyon <lyon@fnal.gov>

# Following instructions from https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallCvmfs

RUN yum -y install yum-plugin-priorities
RUN rpm -Uvh https://repo.grid.iu.edu/osg/3.3/osg-3.3-el6-release-latest.rpm
RUN yum -y install osg-oasis

RUN echo "user_allow_other" > /etc/fuse.conf

COPY osg_cvmfs_default.local /etc/cvmfs/default.local
COPY start.sh /usr/local/bin 

RUN mkdir /cvmfs/gm2.opensciencegrid.org

# Mount CVMFS on entry
# (See http://www.markbetz.net/2014/03/17/docker-run-startup-scripts-then-exit-to-a-shell/)
CMD bash -C '/usr/local/bin/start.sh';'bash' 
