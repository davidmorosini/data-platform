FROM cluster-base

ARG SPARK_VERSION
ARG HADOOP_VERSION
ARG SPARK_HOST_MASTER
ARG SPARK_PORT_MASTER
ARG PYSPARK_PYTHON_VERSION=python3

ARG SPARK_NAME=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ARG SPARK_HOME_PATH=/usr/bin/${SPARK_NAME}
ARG HADOOP_URL=https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_NAME}.tgz

RUN apt-get update -y && \
    apt-get install -y curl && \
    curl ${HADOOP_URL} -o spark.tgz && \
    tar -xf spark.tgz && \
    mv ${SPARK_NAME} /usr/bin/ && \
    rm spark.tgz

RUN mkdir ${SPARK_HOME_PATH}/logs

ENV SPARK_HOME ${SPARK_HOME_PATH}
ENV SPARK_MASTER_HOST ${SPARK_HOST_MASTER}
ENV SPARK_MASTER_PORT ${SPARK_PORT_MASTER}
ENV PYSPARK_PYTHON ${PYSPARK_PYTHON_VERSION}

WORKDIR ${SPARK_HOME}
