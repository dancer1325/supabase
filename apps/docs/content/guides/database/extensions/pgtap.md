---
id: 'pgtap'
title: 'pgTAP: Unit Testing'
description: 'Unit testing in Postgres.'
---

* `pgTAP`
  * == Postgres' unit testing extension
 
* Unit tests
  * allow you to
    * test small parts of a system 
      * _Example:_ database table
* [Test Anything Protocol (TAP)](http://testanything.org/)
  * == framework /
    * 's goal: simplify the error reporting | testing

## Enable the extension

* ways
  * -- via Supabase Dashboard
    * Supabase Dashboard > project > choose a project > database > extensions > enable `pgtap`
  * -- via -- SQL

    ```sql
    -- recommendations
    --      create the extension | separate schema
    --          Reason: keep the `public` schema clean  
    create extension pgtap with schema extensions;
    ```

## Testing tables

* API
  * [`has_table()`](https://pgtap.org/documentation.html#has_table)
    * whether a table exists | the database
  * [`has_index()`](https://pgtap.org/documentation.html#has_index)
    * whether exist a named index / associated -- with -- the named table
  * [`has_relation()`](https://pgtap.org/documentation.html#has_relation)
    * whether a relation exists | the database

## Testing columns

* API
  * [`has_column()`](https://pgtap.org/documentation.html#has_column)
    * whether a column exists | a given table/view/materialized view OR composite type
  * [`col_is_pk()`](https://pgtap.org/documentation.html#col_is_pk)
    * whether the table's column OR columns is/are the table's primary key 

## Testing RLS policies

* API
  * [`policies_are()`](https://pgtap.org/documentation.html#policies_are)
    * Tests that all of the policies on the named table are only the policies that should be on that table
  * [`policy_roles_are()`](https://pgtap.org/documentation.html#policy_roles_are)
    * Tests whether the roles to which policy applies are only the roles that should be on that policy.
  * [`policy_cmd_is()`](https://pgtap.org/documentation.html#policy_cmd_is)
    * Tests whether the command to which policy applies is same as command that is given in function arguments.
  * [`results_eq()`](https://pgtap.org/documentation.html#results_eq)
    * whether a policy returns the correct data
  * [`results_ne()`](https://pgtap.org/documentation.html#results_ne)

## Testing functions

* API
  * [`function_returns()`](https://pgtap.org/documentation.html#function_returns)
    * a particular function returns a particular data type
  * [`is_definer()`](https://pgtap.org/documentation.html#is_definer)
    * a function 
      * == security definer 
        * == `setuid` function
