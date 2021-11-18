FROM pyspark

ARG JUPYTERLAB_VERSION
ARG ROOT_PATH=/opt/workspace

RUN pip install jupyterlab==${JUPYTERLAB_VERSION}

EXPOSE 8888

# Env Variable SHARED_WORKSPACE has defined in cluster-base image
WORKDIR ${SHARED_WORKSPACE}

ENV PYTHONPATH=${PYTHONPATH}:${ROOT_PATH}/plugins

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
