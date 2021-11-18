FROM spark-base

ARG SPARK_MASTER_WEB_UI_PORT

# Env Variable SPARK_MASTER_PORT has defined in spark-base image
EXPOSE ${SPARK_MASTER_WEB_UI_PORT} ${SPARK_MASTER_PORT}
CMD bin/spark-class org.apache.spark.deploy.master.Master
