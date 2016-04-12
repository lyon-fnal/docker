FROM lyonfnal/mu_1_17_07_base

MAINTAINER Adam Lyon <lyon@fnal.gov>

USER root

RUN yum install -y libffi-devel graphviz-devel lapack-devel && \
    yum clean all

USER gm2

RUN source /products/setup && \
  setup art v1_17_07 -q prof:e9 && \
  setup cmake v3_3_2 && \
  curl -O https://bootstrap.pypa.io/get-pip.py && \
  python get-pip.py --user && \
  rm -f get-pip.py && \
  export PATH=/home/gm2/.local/bin:$PATH && \
  pip2 --no-cache-dir install --user requests[security] && \
  pip2 --no-cache-dir install --user ipykernel && \
  pip2 --no-cache-dir install --user jupyter && \
  pip2 --no-cache-dir install --user widgetsnbextension && \
  pip2 --no-cache-dir install --user nbconvert && \
  pip2 --no-cache-dir install --user numpy && \
  pip2 --no-cache-dir install --user pandas && \
  pip2 --no-cache-dir install --user matplotlib && \
  pip2 --no-cache-dir install --user seaborn

ENV PATH /home/gm2/.local/bin:$PATH

COPY startenv.sh /usr/local/bin/startenv.sh

ADD root_v6.06.02.source.tar.gz /home/gm2/root_v6.06.02

WORKDIR /home/gm2

USER root
RUN chown -R gm2 /home/gm2/root_v6.06.02
USER gm2

RUN cd /home/gm2 && \
    source /usr/local/bin/startenv.sh && \
    cd root_v6.06.02 && \
    mkdir build && \
    cd build && \
    CXX=g++ CC=gcc cmake -Dcxx11=OFF -Dcxx14=ON ../root-6.06.02 && \
    make -j4

RUN mkdir -p /home/gm2/.local/share/jupyter/kernels && \
    cp -rv /home/gm2/root_v6.06.02/build/etc/notebook/kernels/root /home/gm2/.local/share/jupyter/kernels

COPY jupyter_notebook_config.py /home/gm2/.jupyter/jupyter_notebook_config.py

USER root
RUN chown -R gm2 /home/gm2/.jupyter
USER gm2

COPY dot_bash_profile /home/gm2/.bash_profile

# Load jupyter extensions
RUN cd /home/gm2 && \
    source /usr/local/bin/startenv.sh && \
    pip install https://github.com/ipython-contrib/IPython-notebook-extensions/archive/master.zip --user && \
    cd $(jupyter --data-dir)/nbextensions && \
    mkdir jupyter_themes && cd jupyter_themes && \
    wget https://raw.githubusercontent.com/merqurio/jupyter_themes/master/theme_selector.js && \
    cd ../ && jupyter nbextension enable jupyter_themes/theme_selector

# Load nbextensions and dependencies (pandoc and TeXLive)
USER root
RUN curl -sSL https://s3.amazonaws.com/download.fpcomplete.com/centos/6/fpco.repo | tee /etc/yum.repos.d/fpco.repo && \
    yum install -y stack texlive-latex && \
    yum clean all && \
    cd /home/gm2 && \
    wget https://hackage.haskell.org/package/pandoc-1.17.0.3/pandoc-1.17.0.3.tar.gz && \
    tar xvzf pandoc-1.17.0.3.tar.gz && \
    cd pandoc-1.17.0.3 && \
    stack setup && \
    stack install && \
    cd .. && \
    rm -rf pandoc*
USER gm2

RUN cd /home/gm2 && \
    source /usr/local/bin/startenv.sh && \
    pip2 --no-cache-dir install jupyter --upgrade --user

CMD bash -l

EXPOSE 8888
