FROM apache/airflow:2.1.2 AS base

ARG ROOT_PATH=/opt/airflow

COPY requirements.txt .

RUN pip install --upgrade pip & \
    pip install -r requirements.txt

WORKDIR ${ROOT_PATH}

ENV PYTHONPATH=${PYTHONPATH}:${ROOT_PATH}/dags:${ROOT_PATH}/plugins
