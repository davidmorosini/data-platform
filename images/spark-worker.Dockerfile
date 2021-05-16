FROM spark-base

ARG SPARK_MASTER_WEB_UI=8081

EXPOSE ${SPARK_MASTER_WEB_UI}
CMD bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}
