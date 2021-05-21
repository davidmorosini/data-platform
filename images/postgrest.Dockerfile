FROM debian

ARG POSTGREST_VERSION=v7.0.1
ARG POSTGREST_PLATFORM=linux-x64-static

WORKDIR /app
COPY postgrest.conf .

EXPOSE 3000

# Install PostgREST
RUN apt-get update -y && \
    apt-get install -y wget xz-utils && \
    wget https://github.com/PostgREST/postgrest/releases/download/${POSTGREST_VERSION}/postgrest-${POSTGREST_VERSION}-${POSTGREST_PLATFORM}.tar.xz && \
    tar xJf postgrest-${POSTGREST_VERSION}-${POSTGREST_PLATFORM}.tar.xz && \
    rm postgrest-${POSTGREST_VERSION}-${POSTGREST_PLATFORM}.tar.xz && \
    chmod 700 ./postgrest

ENTRYPOINT ["./postgrest",  "postgrest.conf"]
