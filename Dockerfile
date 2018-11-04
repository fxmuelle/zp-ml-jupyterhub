FROM jupyter/scipy-notebook:latest

ADD . /home/jovyan/

WORKDIR /home/jovyan

RUN pip install nbgitpuller
RUN jupyter serverextension enable --py nbgitpuller --sys-prefix

# Expose the notebook port
EXPOSE 8888

# Start the notebook server
CMD jupyter notebook --no-browser --port 8888 --ip=*