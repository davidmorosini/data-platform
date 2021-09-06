# dataservice
My personal Infrastructure of Data As a Service


## All Build

```sh
make build-all
```

## Spark Cluster

this environment contains a spark cluster with 2 workers and a Jupyter Lab instance to prototype.

```sh
make run-spark
```

This execution results in:

- http://localhost:8888/  -> Jupyter lab Interface (Connected with spark cluster)
- http://localhost:8081/  -> Spark master Interface
- http://localhost:8082/  -> Spark worker 1 Interface
- http://localhost:8083/  -> Spark worker 2 Interface


## Airflow Cluster

this environment contains a airflow cluster with 1 worker.

```sh
make run-airflow
```

http://localhost:8888/ 


This execution results in:
- http://localhost:8080/  -> Airflow Webservice Interface


## Postgres as REST API

```sh
make build-postgrest
make run-olap
```

Execute os comandos abaixo no console SQL
```sql
create schema olap;

create table olap.todos (
  id serial primary key,
  done boolean not null default false,
  task text not null,
  due timestamptz
);

insert into olap.todos (task) values
  ('finish tutorial 0'), ('pat self on back');
  

create role web_anon nologin;

grant usage on schema olap to web_anon;
grant select on olap.todos to web_anon;
```


Consulte em:
```
http://localhost:3000/todos
```