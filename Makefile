include .env

default: build-all

build-all: build-all-clusters build-jupyter

build-all-clusters: build-spark-cluster

build-spark-cluster:
	@docker build \
		-f ${DOCKER_IMAGES_SPARK}/cluster-base.Dockerfile \
		-t cluster-base .
	@docker build \
		--build-arg SPARK_VERSION="${VERSION_SPARK}" \
		--build-arg HADOOP_VERSION="${VERSION_HADOOP}" \
		-f ${DOCKER_IMAGES_SPARK}/spark-base.Dockerfile \
		-t spark-base .
	@docker build \
		-f ${DOCKER_IMAGES_SPARK}/spark-master.Dockerfile \
		-t spark-master .
	@docker build \
		-f ${DOCKER_IMAGES_SPARK}/spark-worker.Dockerfile \
		-t spark-worker .
	@docker build \
		--build-arg SPARK_VERSION="${VERSION_SPARK}" \
		-f ${DOCKER_IMAGES_SPARK}/pyspark.Dockerfile \
		-t pyspark .

build-jupyter: build-spark-cluster
	@docker build \
		--build-arg JUPYTERLAB_VERSION="${VERSION_JUPYTERLAB}" \
		-f ${DOCKER_IMAGES}/jupyterlab.Dockerfile \
		-t jupyterlab .

build-postgrest:
	@docker build \
		--build-arg POSTGREST_VERSION="v7.0.1" \
		--build-arg POSTGREST_PLATFORM="linux-x64-static" \
		-f ${DOCKER_IMAGES}/postgrest.Dockerfile \
		-t postgrest .

run:
	@docker-compose up

run-spark:
	@docker-compose up jupyterlab spark-master spark-worker-1 spark-worker-2

run-olap:
	@docker-compose up olap postgrest
