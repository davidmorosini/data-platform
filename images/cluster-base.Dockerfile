ARG debian_buster_image_tag=11-jre-slim
FROM openjdk:${debian_buster_image_tag}

ARG CLUSTER_SHARED_WORKSPACE=/opt/workspace

RUN mkdir -p ${CLUSTER_SHARED_WORKSPACE}

# Install python
RUN apt-get update -y && \
    apt-get install -y python3 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

ENV SHARED_WORKSPACE=${CLUSTER_SHARED_WORKSPACE}

# Simulando o Hadoop com um volume compartilhado
VOLUME ${CLUSTER_SHARED_WORKSPACE}
CMD ["bash"]