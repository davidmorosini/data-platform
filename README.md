# Data Service

This project builds my **simple** structure of **data as a service**, including some platforms and tools for processing and provide data.

---

## Platforms Included

|                   Platform                    | version |
|:---------------------------------------------:|:-------:|
| [Apache Airflow](https://airflow.apache.org/) |  2.1.2  |
|   [Apache Spark](https://spark.apache.org/)   |  3.1.2  |
|  [Apache Hadoop](https://hadoop.apache.org/)  |   3.2   |
|      [PostgREST](https://postgrest.org/)      | v7.0.1  |

---

## Run Locally

|                  Need to install                   | tested version |       tested build       |
|:--------------------------------------------------:|:--------------:|:------------------------:|
|  [Docker Engine](https://docs.docker.com/engine/)  |    20.10.7     | 20.10.7-0ubuntu1~20.04.2 |
| [docker-compose](https://docs.docker.com/compose/) |     1.29.2     |         5becea4c         |

### Initial steps

- First, Build all docker images

```bash
make
```

### Run All Clusters

- Just, run it

```bash
make run-all-clusters
```

|         Interface         |                   URL                    |
|:-------------------------:|:----------------------------------------:|
|    Airflow Webservice     | [localhost:8080](http://localhost:8080/) |
|  Spark Master Webservice  | [localhost:8081](http://localhost:8081/) |
| Spark Worker 1 Webservice | [localhost:8082](http://localhost:8082/) |
| Spark Worker 2 Webservice | [localhost:8083](http://localhost:8083/) |
|  Jupyter Lab Webservice   | [localhost:8888](http://localhost:8888/) |

:warning: For run each service alone, please see the `Makefile`

### Run QAS (Linter + Tests) Locally

- Just, run it

```bash
make qas
```

:warning: Black execution can be modify your code (Including Jupyter Notebooks) follow black's code guidestyle.

---
