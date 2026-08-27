-- 1. create a basic database function
create or replace function hello_world()    -- function declaration
returns text                                -- type of data / function returns
language sql                                -- language / used | function body
as $$ select 'hello world'; $$;              -- function body

-- 2. execute the function
select hello_world();

-- 3. return data sets
create table planets (
                         id serial primary key,
                         name text
);

insert into planets
(id, name)
values
    (1, 'Tattoine'),
    (2, 'Alderaan'),
    (3, 'Kashyyyk');

create table people (
                        id serial primary key,
                        name text,
                        planet_id bigint references planets
);

insert into people
(id, name, planet_id)
values
    (1, 'Anakin Skywalker', 1),
    (2, 'Luke Skywalker', 1),
    (3, 'Princess Leia', 2),
    (4, 'Chewbacca', 3);

create or replace function get_planets()
    returns setof planets
    language sql
as $$
select * from planets;
$$;

-- 3.1 apply filters & selectors
select *
from get_planets()
where id = 1;

-- 4. Passing parameters
create or replace function add_planet(name text)
    returns bigint
    language plpgsql
as $$
declare
    new_row bigint;
begin
    insert into planets(name)
    values (add_planet.name)
    returning id into new_row;

    return new_row;
end;
$$;

select * from add_planet('Jakku');

\dp;