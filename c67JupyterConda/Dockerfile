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
RUN mkdir -p /opt/miniconda && chown gm2 /opt/miniconda && \
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

# We need some of our own scripts
USER root
COPY startJupyter.sh /usr/local/bin

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

EXPOSE 8888
