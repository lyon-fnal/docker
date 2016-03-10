FROM jupyter/scipy-notebook

MAINTAINER Adam Lyon <lyon@fnal.gov>

# Add nbextensions
#RUN mkdir -p /home/jovyan/.local/share/jupyter && \
#    pip install https://github.com/ipython-contrib/IPython-notebook-extensions/archive/master.zip

USER jovyan

# Add new packages via conda (we're just going to do python2)
RUN conda install -y -n python2 xlrd sqlalchemy sqlparse numexpr && conda clean -yt

# Install ipython-sql via Pip (only to python2)
RUN bash -c "source activate python2 && pip install ipython-sql"
