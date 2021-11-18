FROM cluster-base

ARG PYSPARK_VERSION

RUN apt-get update -y && \
    apt-get install -y python3 && \
    apt-get install -y python3-pip && \
    python3 -m pip install --upgrade pip

COPY requirements.txt /tmp

RUN pip install pyspark==${PYSPARK_VERSION} && \
    pip install -r /tmp/requirements.txt
