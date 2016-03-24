# Build a docker image with the Allinea Forge debugger/profiler

FROM lyonfnal/c67cvmfsnfsclient

MAINTAINER Adam Lyon <lyon@fnal.gov>

USER root

RUN yum install -y libXrender fontconfig gdb-gdbserver curl && \
    yum clean all

RUN mkdir -p /home/root/allinea && \
    cd /home/root/allinea && \
    curl -o allinea.tar \
            http://content.allinea.com/downloads/allinea-forge-6.0.1-Redhat-6.0-x86_64.tar && \
    tar xvf allinea.tar && \
    cd allinea-forge-6.0.1-Redhat-6.0-x86_64 && \
    ./textinstall.sh --accept-license /opt/allinea/forge && \
    cd /home/root && \
    rm -rf allinea

USER gm2
WORKDIR /home/gm2
RUN echo 'export PATH=/opt/allinea/forge/bin:${PATH}' > setup_allinea && \
    echo 'export PATH=/opt/allinea/forge/bin:${PATH}' >> .bash_profile
