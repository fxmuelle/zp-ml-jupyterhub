FROM jupyter/scipy-notebook:latest

USER root

RUN apt-get update
RUN apt-get install -y graphviz

USER jovyan

ADD . /home/jovyan/

WORKDIR /home/jovyan

RUN pip install --upgrade pip graphviz pydotplus pydot jupyterlab-server alembic appdirs asn1crypto async-generator attrs Automat backcall beautifulsoup4 bleach bokeh cffi chardet cloudpickle conda constantly cryptography cycler Cython dask decorator dill entrypoints fastcache gmpy2 h5py html5lib hyperlink idna imageio incremental ipykernel ipython ipython-genutils ipywidgets jedi Jinja2 jsonschema jupyter-client jupyter-core jupyterhub jupyterlab jupyterlab-launcher kiwisolver llvmlite Mako MarkupSafe matplotlib mistune nbconvert nbformat nbgitpuller networkx notebook numba numexpr numpy olefile packaging pamela pandas pandocfilters parso patsy pexpect pickleshare Pillow pip prometheus-client prompt-toolkit protobuf ptyprocess pyasn1 pyasn1-modules pycosat pycparser pycurl Pygments pyOpenSSL pyparsing PySocks python-dateutil python-editor python-oauth2 pytz PyWavelets PyYAML pyzmq requests ruamel-yaml scikit-image scikit-learn scipy seaborn Send2Trash service-identity setuptools simplegeneric six SQLAlchemy statsmodels terminado testpath toolz tornado traitlets Twisted urllib3 vincent wcwidth webencodings wheel widgetsnbextension xlrd zope.interface
RUN pip install nbgitpuller
RUN jupyter serverextension enable --py nbgitpuller --sys-prefix
RUN jupyter labextension install @jupyterlab/hub-extension

# Expose the notebook port
EXPOSE 8888

# Start the notebook server
CMD jupyter-labhub --no-browser --port 8888 --ip=*