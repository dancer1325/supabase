-- supabase/migrations/<timestamp>_create_employees_table.sql
create table if not exists employees (
     id bigint primary key generated always as identity,
     name text not null,
     email text,
     created_at timestamptz default now()
);

-- uncomment AFTER running `supabase migration new add_department_column`
-- supabase/migrations/<timestamp>_add_department_column.sql
-- alter table if exists public.employees
--     add department text default 'Hooli';

