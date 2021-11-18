create schema warehouse;

create table warehouse.tasks (
  id serial primary key,
  done boolean not null default false,
  task text not null,
  created_at timestamptz not null default current_timestamp,
  updated_at timestamptz not null default current_timestamp
);

insert into warehouse.tasks (task) values
  ('Task Number 1'),
  ('Task Number 2');
  

create role postgrest_anon nologin;

grant usage on schema warehouse to postgrest_anon;
grant select on warehouse.tasks to postgrest_anon;
