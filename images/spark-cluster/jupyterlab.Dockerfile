FROM pyspark

ARG JUPYTERLAB_VERSION=3.0.15

RUN pip install jupyterlab==${JUPYTERLAB_VERSION}

EXPOSE 8888

# A variável SHARED_WORKSPACE foi definida no cluster-base
WORKDIR ${SHARED_WORKSPACE}

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
