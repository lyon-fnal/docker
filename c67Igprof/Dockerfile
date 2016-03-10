# Build a docker image with the igprof profiler

FROM c67cvmfsnfsclient

MAINTAINER Adam Lyon <lyon@fnal.gov>

USER root

RUN wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo && \
    yum clean all && \
    yum -y install cmake sqlite devtoolset-2-gcc devtoolset-2-gcc-c++ devtoolset-2-binutils && \
    yum clean all

ENV IGPROF_VERSION=5.9.16
ENV LIBATOMIC_VERSION=7.2alpha4
ENV LIBUNWIND_VERSION=1.1

RUN wget http://www.hpl.hp.com/research/linux/atomic_ops/download/libatomic_ops-${LIBATOMIC_VERSION}.tar.gz && \
    wget http://download.savannah.gnu.org/releases/libunwind/libunwind-${LIBUNWIND_VERSION}.tar.gz && \
    wget -Oigprof-${IGPROF_VERSION}.tar.gz https://github.com/igprof/igprof/archive/v${IGPROF_VERSION}.tar.gz && \
    source /opt/rh/devtoolset-2/enable && \
    tar xvzf libatomic_ops-${LIBATOMIC_VERSION}.tar.gz && \
    cd libatomic_ops-${LIBATOMIC_VERSION} && \
    ./configure --prefix=/usr/local && \
    make -j 4 install && \
    cd .. && \
    tar xvzf libunwind-${LIBUNWIND_VERSION}.tar.gz && \
    cd libunwind-${LIBUNWIND_VERSION} && \
    ./configure CPPFLAGS="-I/usr/local/include" CFLAGS="-g -O3" --prefix=/usr/local --disable-block-signals && \
    make -j 4 install && \
    cd .. && \
    tar xvzf igprof-${IGPROF_VERSION}.tar.gz && \
    cd igprof-${IGPROF_VERSION} && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-g -O3" . && \
    make -j 4 install && \
    cd .. && \
    rm -rf *.tar.gz libatomic_ops-${LIBATOMIC_VERSION} libunwind-${LIBUNWIND_VERSION} igprof-${IGPROF_VERSION}

# Expose a port for a igprof web server
EXPOSE 8900

USER gm2
WORKDIR /home/gm2
