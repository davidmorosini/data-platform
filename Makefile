DOCKER_IMAGES=images
SPARK_VERSION="3.0.0"
HADOOP_VERSION="2.7"
JUPYTERLAB_VERSION="3.0.15"

default: build-all

build-all: build-jupyter-spark build-spark-worker build-spark-master

build-cluster-base:
	@docker build -f ${DOCKER_IMAGES}/cluster-base.Dockerfile -t cluster-base .

build-spark-base: build-cluster-base
	@docker build \
		--build-arg SPARK_VERSION="${SPARK_VERSION}" \
		--build-arg HADOOP_VERSION="${HADOOP_VERSION}" \
		-f ${DOCKER_IMAGES}/spark-base.Dockerfile \
		-t spark-base .

build-spark-master: build-spark-base
	@docker build -f ${DOCKER_IMAGES}/spark-master.Dockerfile -t spark-master .

build-spark-worker: build-spark-base
	@docker build -f ${DOCKER_IMAGES}/spark-worker.Dockerfile -t spark-worker .

build-jupyter-spark: build-cluster-base
	@docker build \
		--build-arg SPARK_VERSION="${SPARK_VERSION}" \
		--build-arg JUPYTERLAB_VERSION="${JUPYTERLAB_VERSION}" \
		-f ${DOCKER_IMAGES}/jupyterlab.Dockerfile \
		-t jupyterlab .

run:
	@docker-compose up
