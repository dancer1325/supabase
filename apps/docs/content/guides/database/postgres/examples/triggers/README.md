# prerequirements
* download Docker Desktop
* `npx supabase init` OR `supabase init`
* `npx supabase start` OR `supabase start`

# Postgres' trigger
## executes AUTOMATICALLY a set of actions | table events
TODO:
### _Examples:_ INSERTs, UPDATEs, DELETEs, or TRUNCATE operations
TODO:
# Creating a trigger
TODO:
## trigger's parts
TODO:
### function OR Trigger Function / will be executed
TODO:
### Trigger object
TODO:
#### when to run the trigger
TODO:
# Trigger functions
TODO:
## trigger function == user-defined function / Postgres executes | fire the trigger
TODO:
# Trigger variables
TODO:
## Trigger functions' special variables
TODO:
### provide trigger event's context
TODO:
### provide data being modified
TODO:
### `TG_NAME` - trigger name / is being fired
TODO:
### `TG_WHEN` - trigger event timing
TODO:
#### ALLOWED values: `BEFORE`, `AFTER`
TODO:
### `TG_OP` == operation / triggered the event
TODO:
#### ALLOWED values: `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`
TODO:
### `OLD` == record variable / hold the old row's data | `UPDATE` trigger, `DELETE` trigger
TODO:
### `NEW` == record variable / hold the new row's data | `UPDATE` trigger, `INSERT` triggers
TODO:
### `TG_LEVEL` == trigger level
TODO:
#### ALLOWED values: `ROW` (row-level), `STATEMENT` (statement-level)
TODO:
### `TG_RELID` == table's object ID | trigger is being fired
TODO:
### `TG_TABLE_NAME` == table's name | trigger is being fired
TODO:
### `TG_TABLE_SCHEMA` == table's schema | trigger is being fired
TODO:
### `TG_ARGV` - `[]string` arguments / provided | create the trigger
TODO:
### `TG_NARGS` == number of arguments | `TG_ARGV` array
TODO:
# Types of triggers
TODO:
## trigger BEFORE making changes -- `BEFORE` --
TODO:
## trigger AFTER making changes -- `AFTER` --
TODO:
# Execution frequency
TODO:
## `for each row` == execute the trigger function 1! time / EACH affected row
TODO:
## `for each statement` == execute the trigger function 1! time / entire operation
TODO:
### vs `for each row`: if >1 rows affected / 1! SQL statement -> MORE efficient
TODO:
#### 🧠perform calculations OR updates | groups of rows | 1! time🧠
TODO:
# Dropping a trigger
TODO:
## `drop trigger "trigger_name" on "table_name";` - delete a trigger
TODO:
## ❌if the trigger is | a restricted schema -> you can NOT drop it❌
TODO:
### 🧠due to permission restrictions🧠
TODO:
### SOLUTION1: use `CASCADE` clause / AUTOMATICALLY remove ALL triggers / call it
TODO:
### SOLUTION2: drop the function / it depends on
TODO:
