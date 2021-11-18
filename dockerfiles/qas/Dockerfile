FROM python:3.8.12

ARG ROOT_PATH=/opt/workspace

WORKDIR ${ROOT_PATH}

RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY requirements.qas.txt .
RUN pip install --no-cache-dir -r requirements.qas.txt

COPY . .

ENV PYTHONPATH=${PYTHONPATH}:${ROOT_PATH}/dags:${ROOT_PATH}/plugins
