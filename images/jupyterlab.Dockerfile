FROM cluster-base

ARG SPARK_VERSION=3.0.0
ARG JUPYTERLAB_VERSION=3.0.15

RUN apt-get update -y && \
    apt-get install -y python3-pip && \
    pip3 install wget pyspark==${SPARK_VERSION} jupyterlab==${JUPYTERLAB_VERSION}

EXPOSE 8888

WORKDIR ${SHARED_WORKSPACE}

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=