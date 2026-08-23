---
id: 'postgres-triggers'
title: 'Postgres Triggers'
description: 'Automatically execute SQL on table events.'
subtitle: 'Automatically execute SQL on table events.'
---

* goal 
  * Postgres' trigger

* Postgres' trigger
  * executes
    * AUTOMATICALLY a set of actions | table events 
      * _Examples:_ INSERTs, UPDATEs, DELETEs, or TRUNCATE operations
  * ['s Behavior](https://www.postgresql.org/docs/current/trigger-definition.html)
  * [MORE](https://www.postgresql.org/docs/current/triggers.html)

## Creating a trigger

* trigger's parts
  1. [function OR Trigger Function](../functions) / will be executed 
  2. Trigger object
     * 's parameters
       * when to run the trigger
* [MORE](https://www.postgresql.org/docs/current/sql-createtrigger.html)

## Trigger functions

* trigger function
  * == user-defined [function](../functions) /
    * Postgres executes | fire the trigger

### Trigger variables
 
* Trigger functions' special variables
  * provide
    * trigger event's context
    * data being modified
  * are
    - `TG_NAME`
      * trigger name / is being fired
    - `TG_WHEN`
      * trigger event timing
      * ALLOWED values
        * `BEFORE`
        * `AFTER`
    - `TG_OP`
      * == operation / triggered the event 
      * ALLOWED values
        * `INSERT`
        * `UPDATE`
        * `DELETE`
        * `TRUNCATE`
    - `OLD`
      * == record variable / hold the old row's data |
        * `UPDATE` trigger
        * `DELETE` trigger
    - `NEW`
      * == record variable / hold the new row's data |
        * `UPDATE` trigger
        * `INSERT` triggers 
    - `TG_LEVEL`
      * == trigger level
      * ALLOWED values
        * `ROW`
          * == row-level
        * `STATEMENT`
          * == statement-level 
    - `TG_RELID`
      * == table's object ID | trigger is being fired
    - `TG_TABLE_NAME`
      * == table's name | trigger is being fired
    - `TG_TABLE_SCHEMA`
      * == table's schema | trigger is being fired
    - `TG_ARGV`
      * `[]string` arguments /
        * provided | create the trigger
    - `TG_NARGS`
      * == number of arguments | `TG_ARGV` array

## Types of triggers

### trigger BEFORE making changes -- `BEFORE` --

### trigger AFTER making changes -- `AFTER` --

## Execution frequency

* allowed
  * `for each row`
    * == execute the trigger function 1! time / EACH affected row
  * `for each statement`
    * == execute the trigger function 1! time / entire operation (_Example:_ 1! time / insert)
    * vs `for each row`
      * if there are >1 rows affected / 1! SQL statement -> MORE efficient
        * Reason:🧠perform calculations OR updates | groups of rows | 1! time🧠

## Dropping a trigger

* `drop trigger "trigger_name" on "table_name";`
  * delete a trigger
  * ❌if the trigger is | a restricted schema -> you can NOT drop it❌
    * Reason:🧠due to permission restrictions🧠
    * SOLUTIONS
      * SOLUTION1: use `CASCADE` clause / AUTOMATICALLY remove ALL triggers / call it
      * SOLUTION2: drop the function / it depends on 

        ```sql
        drop function if exists restricted_schema.function_name() cascade;
        ```
