ARG debian_image_tag=11-jre-slim

FROM openjdk:${debian_image_tag}

ARG CLUSTER_SHARED_WORKSPACE=/opt/workspace

RUN mkdir -p ${CLUSTER_SHARED_WORKSPACE}

ENV SHARED_WORKSPACE=${CLUSTER_SHARED_WORKSPACE}

# Simulando o Hadoop com um volume compartilhado
VOLUME ${CLUSTER_SHARED_WORKSPACE}

CMD ["bash"]
