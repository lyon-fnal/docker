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

# Setup directories
RUN mkdir -p /opt/products && chown gm2 /opt/products && \
    mkdir -p /opt/miniconda && chown gm2 /opt/miniconda && \
    mkdir -p /opt/pandoc && chown gm2 /opt/pandoc

USER gm2

# Install Miniconda with initial suite of programs
RUN mkdir -p /home/gm2/.local/share/jupyter && \
    wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    bash Miniconda2-latest-Linux-x86_64.sh -p /opt/miniconda -b -f && \
    source /opt/miniconda/bin/activate /opt/miniconda && \
      conda install -y notebook && \
      conda install -y pandas && \
      conda install -y seaborn && \
      conda install -y holoviews && \
      conda install -y datashader && \
      conda install -y ipywidgets && \
      conda install -y sympy && \
      conda install -y scikit-learn && \
      conda install -y scikit-image && \
      conda install -y nbconvert && \
      conda install -y -c r r-essentials && \
      conda install -y -c r rpy2 && \
      conda clean -tipsy && \
      pip install https://github.com/ipython-contrib/IPython-notebook-extensions/archive/master.zip

# Get Root and friends from SciSoft
COPY 	art-adam-Linux64bit+2.6-2.12-e9-prof_MANIFEST.txt /home/gm2
RUN wget http://scisoft.fnal.gov/scisoft/bundles/tools/pullProducts && \
    chmod a+x pullProducts && \
    ./pullProducts -r -l /opt/products slf6 art-adam e9 prof
ENV PYTHON_DATA_PLATFORM_2710 /opt/python_data_platform_2710
USER root
RUN mkdir -p $PYTHON_DATA_PLATFORM_2710 && chown gm2 $PYTHON_DATA_PLATFORM_2710
USER gm2

# Setup running Jupyter Notebooks
RUN source /opt/products/setup && \
    setup root v6_06_02 -q e9:prof && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py --prefix=$PYTHON_DATA_PLATFORM_2710 && \
    rm -f get-pip.py && \
    export PATH=$PYTHON_DATA_PLATFORM_2710/bin:$PATH && \
    export LD_LIBRARY_PATH=$PYTHON_DATA_PLATFORM_2710/lib:$LD_LIBRARY_PATH && \
    export PYTHONPATH=$PYTHON_DATA_PLATFORM_2710/lib/python2.7/site-packages:$PYTHONPATH && \
    pip2 --no-cache-dir install --prefix=$PYTHON_DATA_PLATFORM_2710 ipykernel && \
    pip2 --no-cache-dir install --prefix=$PYTHON_DATA_PLATFORM_2710 ipywidgets

# We need some of our own scripts
USER root
COPY root-notebook-launcher.sh /usr/local/bin
COPY setupRoot /usr/local/bin
COPY startJupyter.sh /usr/local/bin

# Startup
RUN wget https://github.com/krallin/tini/releases/download/v0.6.0/tini && \
    chmod a+x tini && \
    mv tini /usr/local/bin

# Copy jupyter kernels
USER gm2
RUN mkdir -p /home/gm2/.local/share/jupyter/kernels/root-python && \
    mkdir -p /home/gm2/.local/share/jupyter/kernels/root-cxx
COPY root-python-kernel.json /home/gm2/.local/share/jupyter/kernels/root-python/kernel.json
COPY root-cxx-kernel.json /home/gm2/.local/share/jupyter/kernels/root-cxx/kernel.json

# Fix stuff
USER root
RUN chmod a+x /usr/local/bin/startCvmfsNfsClient.sh

USER gm2
RUN mkdir /home/gm2/notebooks
WORKDIR /home/gm2/notebooks

EXPOSE 8888
EXPOSE 8889
