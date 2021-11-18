FROM debian

ARG POSTGREST_VERSION
ARG POSTGREST_PLATFORM
ARG POSTGREST_PORT

ARG POSTGREST_NAME=postgrest-${POSTGREST_VERSION}-${POSTGREST_PLATFORM}.tar.xz
ARG POSTGREST_URL=https://github.com/PostgREST/postgrest/releases/download/${POSTGREST_VERSION}/${POSTGREST_NAME}

WORKDIR /app

COPY postgrest.conf .

EXPOSE ${POSTGREST_PORT}

RUN apt-get update -y && \
    apt-get install -y wget xz-utils && \
    wget ${POSTGREST_URL} && \
    tar xJf ${POSTGREST_NAME} && \
    rm ${POSTGREST_NAME} && \
    chmod 700 ./postgrest

ENTRYPOINT ["./postgrest",  "postgrest.conf"]
