-- 1. create a trigger function
create trigger "trigger_name"
    after insert on "table_name"
    for each row
    execute function trigger_function();

-- 2. TODO:
--      Example: Update salary_log | update salary's employee
--    `old`
--          == previous values
--     `new`
--          == updated values
create function update_salary_log()
    returns trigger
    language plpgsql
as $$
begin
insert into salary_log(employee_id, old_salary, new_salary)
values (new.id, old.salary, new.salary);
return new;
end;
$$;

create trigger salary_update_trigger
    after update on employees
    for each row
    execute function update_salary_log();

-- 3. types of triggers
-- 3.1 BEFORE
create trigger before_insert_trigger
    before insert on orders
    for each row
    execute function before_insert_function();
-- 3.2 AFTER
create trigger after_delete_trigger
    after delete on customers
    for each row
    execute function after_delete_function();