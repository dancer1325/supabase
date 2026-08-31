-- 20250101000000_create_employees_table.sql
create table employees (
                           id bigint primary key generated always as identity,
                           name text,
                           email text,
                           created_at timestamptz default now()
);