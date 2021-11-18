include .env

SHELL := /bin/bash


default: build-all

########################  BUILD  ########################

build-all: build-all-clusters build-postgrest

build-all-clusters: build-spark-cluster build-airflow-cluster

build-airflow-cluster:
	@mkdir -p logs/airflow
	@docker build \
		-f dockerfiles/airflow/Dockerfile \
		-t airflow-base .

build-spark-cluster: build-spark-cluster-base \
	build-spark-base \
	build-spark-master \
	build-spark-worker \
	build-pyspark \
	build-jupyter-with-spark

build-spark-cluster-base:
	@docker build \
		-f dockerfiles/spark/cluster-base.Dockerfile \
		-t cluster-base .

build-spark-base:
	@docker build \
		--build-arg SPARK_VERSION=${SPARK_VERSION} \
		--build-arg HADOOP_VERSION=${HADOOP_VERSION} \
		--build-arg SPARK_HOST_MASTER=${SPARK_HOST_MASTER} \
		--build-arg SPARK_PORT_MASTER=${SPARK_PORT_MASTER} \
		-f dockerfiles/spark/spark-base.Dockerfile \
		-t spark-base .

build-spark-master:
	@docker build \
		--build-arg SPARK_MASTER_WEB_UI_PORT=${SPARK_MASTER_WEB_UI_PORT_MASTER} \
		-f dockerfiles/spark/spark-master.Dockerfile \
		-t spark-master .

build-spark-worker:
	@docker build \
		--build-arg SPARK_MASTER_WEB_UI_PORT=${SPARK_MASTER_WEB_UI_PORT_WORKER} \
		-f dockerfiles/spark/spark-worker.Dockerfile \
		-t spark-worker .

build-pyspark:
	@docker build \
		--build-arg PYSPARK_VERSION=${SPARK_VERSION} \
		-f dockerfiles/spark/pyspark.Dockerfile \
		-t pyspark .

build-jupyter-with-spark: build-spark-cluster
	@docker build \
		--build-arg JUPYTERLAB_VERSION=${JUPYTERLAB_VERSION} \
		-f dockerfiles/spark/jupyterlab.Dockerfile \
		-t jupyterlab .

build-postgrest:
	@docker build \
		--build-arg POSTGREST_VERSION=${POSTGREST_VERSION} \
		--build-arg POSTGREST_PLATFORM=${POSTGREST_PLATFORM} \
		-f dockerfiles/postgrest/Dockerfile \
		-t postgrest .

########################  EXECUTION  ########################


run-spark: build-spark-cluster
	@docker-compose up spark-master spark-worker-1 spark-worker-2 jupyterlab

run-spark-without-jupyter: build-spark-cluster-base build-spark-base build-spark-master build-spark-worker
	@docker-compose up spark-master spark-worker-1 spark-worker-2

run-jupyter-notebook: build-pyspark build-jupyter-with-spark
	@docker-compose up jupyterlab

run-airflow: build-airflow-cluster
	@docker-compose up postgres redis airflow-webserver airflow-scheduler airflow-worker airflow-init flower

# run-olap:
# 	@docker-compose up olap postgrest
