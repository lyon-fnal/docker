FROM lyonfnal/c67cvmfsnfsclient

MAINTAINER Adam Lyon <lyon@fnal.gov>

USER root

# Install system dependencies for root
RUN yum install -y libffi-devel graphviz-devel lapack-devel libXft-devel && \
    yum clean all

# Install LaTeX and lsb_release (used by ups)
RUN curl -sSL https://s3.amazonaws.com/download.fpcomplete.com/centos/6/fpco.repo | tee /etc/yum.repos.d/fpco.repo && \
    yum install -y stack texlive-latex redhat-lsb-core && \
    yum clean all

# Set location of python extra stuff
ENV PYTHON_DATA_PLATFORM_2710 /opt/python_data_platform_2710

# Setup directories
RUN mkdir -p /opt/products && chown gm2 /opt/products && \
    mkdir -p /opt/pandoc && chown gm2 /opt/pandoc && \
    mkdir -p $PYTHON_DATA_PLATFORM_2710 && chown gm2 $PYTHON_DATA_PLATFORM_2710

USER gm2

# Get Root and friends from SciSoft
COPY 	art-adam-Linux64bit+2.6-2.12-e9-prof_MANIFEST.txt /home/gm2
RUN wget http://scisoft.fnal.gov/scisoft/bundles/tools/pullProducts && \
    chmod a+x pullProducts && \
    ./pullProducts -r -l /opt/products slf6 art-adam e9 prof

# Setup running Jupyter Notebooks
RUN source /opt/products/setup && \
    setup root v6_06_02 -q e9:prof && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py --prefix=$PYTHON_DATA_PLATFORM_2710 && \
    rm -f get-pip.py && \
    export PATH=$PYTHON_DATA_PLATFORM_2710/bin:$PATH && \
    export LD_LIBRARY_PATH=$PYTHON_DATA_PLATFORM_2710/lib:$LD_LIBRARY_PATH && \
    export PYTHONPATH=$PYTHON_DATA_PLATFORM_2710/lib/python2.7/site-packages:$PYTHONPATH && \
    pip2 --no-cache-dir install --prefix=$PYTHON_DATA_PLATFORM_2710 psutil  && \
    pip2 --no-cache-dir install --prefix=$PYTHON_DATA_PLATFORM_2710 jupyter && \
    pip2 --no-cache-dir install --prefix=$PYTHON_DATA_PLATFORM_2710 ipykernel && \
    pip2 --no-cache-dir install --prefix=$PYTHON_DATA_PLATFORM_2710 ipywidgets && \
    pip2 --no-cache-dir install --prefix=$PYTHON_DATA_PLATFORM_2710 widgetsnbextension && \
    pip2 --no-cache-dir install --prefix=$PYTHON_DATA_PLATFORM_2710 nbconvert && \
    mkdir -p /home/gm2/.local/share/jupyter && \
    pip2 --no-cache-dir install --prefix=$PYTHON_DATA_PLATFORM_2710 https://github.com/ipython-contrib/IPython-notebook-extensions/archive/master.zip && \
    cp -rv $ROOT_DIR/Linux64bit+2.6-2.12-e9-prof/etc/notebook/kernels /home/gm2/.local/share/jupyter/kernels

# We need some of our own scripts
USER root
COPY startJupyterRoot.sh /usr/local/bin

# Startup
RUN wget https://github.com/krallin/tini/releases/download/v0.6.0/tini && \
    chmod a+x tini && \
    mv tini /usr/local/bin

# Fix stuff
USER root
RUN chmod a+x /usr/local/bin/startCvmfsNfsClient.sh

USER gm2
RUN mkdir /home/gm2/notebooks
WORKDIR /home/gm2/notebooks

EXPOSE 8889
