include .env

default: build-all

build-all: build-all-clusters

build-all-clusters: build-spark-cluster

build-spark-cluster: build-spark-cluster-base build-spark-base build-spark-master build-spark-worker build-pyspark build-jupyter-with-spark

build-spark-cluster-base:
	@docker build \
		-f ${DOCKER_IMAGES}/spark-cluster/cluster-base.Dockerfile \
		-t cluster-base .

build-spark-base:
	@docker build \
		--build-arg SPARK_VERSION=${SPARK_VERSION} \
		--build-arg HADOOP_VERSION=${HADOOP_VERSION} \
		-f ${DOCKER_IMAGES}/spark-cluster/spark-base.Dockerfile \
		-t spark-base .

build-spark-master:
	@docker build \
		-f ${DOCKER_IMAGES}/spark-cluster/spark-master.Dockerfile \
		-t spark-master .

build-spark-worker:
	@docker build \
		-f ${DOCKER_IMAGES}/spark-cluster/spark-worker.Dockerfile \
		-t spark-worker .

build-pyspark:
	@docker build \
		--build-arg SPARK_VERSION=${SPARK_VERSION} \
		-f ${DOCKER_IMAGES}/spark-cluster/pyspark.Dockerfile \
		-t pyspark .

build-jupyter-with-spark: build-spark-cluster
	@docker build \
		--build-arg JUPYTERLAB_VERSION=${VERSION_JUPYTERLAB} \
		-f ${DOCKER_IMAGES}/spark-cluster/jupyterlab.Dockerfile \
		-t jupyterlab .

build-postgrest:
	@docker build \
		--build-arg POSTGREST_VERSION=v7.0.1 \
		--build-arg POSTGREST_PLATFORM=linux-x64-static \
		-f ${DOCKER_IMAGES}/postgrest.Dockerfile \
		-t postgrest .

run:
	@docker-compose up

run-spark:
	@docker-compose up spark-master spark-worker-1 spark-worker-2 jupyterlab

run-olap:
	@docker-compose up olap postgrest
