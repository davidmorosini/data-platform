# dataservice
My personal Data As a Service project

Para executar:
```sh
make build-all
make run
```

Saídas:
- http://localhost:8888/  -> Jupyter lab Interface (Conectado com o spark cluster)
- http://localhost:8080/  -> Spark master Interface
- http://localhost:8081/  -> Spark worker 1 Interface
- http://localhost:8082/  -> Spark worker 2 Interface



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