FROM spark-base

ARG SPARK_MASTER_WEB_UI_PORT

EXPOSE ${SPARK_MASTER_WEB_UI_PORT}
# Env Variables SPARK_MASTER_HOST and SPARK_MASTER_PORT has defined in spark-base image
CMD bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}
