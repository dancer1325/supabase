---
id: 'functions'
title: 'Database Functions'
description: 'Creating and using Postgres functions.'
video: 'https://www.youtube.com/v/MJZCCpCYEqk'
---

* Postgres
  * has built-in support for [SQL functions](https://www.postgresql.org/docs/current/sql-createfunction.html) /
    * live | your database
    * uses
      * [with the API](../../reference/javascript/rpc)
  * [Postgres's Chapter 9. Functions and Operators](https://www.postgresql.org/docs/current/functions.html)

## Quick demo

* [video](https://www.youtube.com/watch?v=MJZCCpCYEqk)
  * TODO:

## Getting started

* ways to create database functions / provided -- by -- Supabase
  * | Supabase Dashboard > SQL editor 
    * steps
      * "New Query" > enter the SQL > run
  * -- via -- SQL
    * steps
      * [connect -- to -- your database](../../guides/database/connecting-to-postgres)
      * run the SQL queries

## Basic functions [#simple-functions]

* 's parts
  * `create function <FUNCTION_NAME>` OR `replace function <FUNCTION_NAME>` OR `create or replace function <FUNCTION_NAME>`
    * == function declaration
    * `<FUNCTION_NAME>`
      * requirements
        * ⚠️MUST be unique⚠️
          * Reason:🧠overloaded functions are NOT supported🧠
  * `returns <RETURNED_TYPE>`
    * == type of data / function returns 
      * ALLOWED `<RETURNED_TYPE>`
        * scalar value
        * NOTHING == `returns void`
          * == nothing is returned
        * [tables' data sets OR views' data sets](#returning-data-sets) 
  * `language sql` OR `language <ANY_PROCEDURAL_LANGUAGE>`
    * == language / used | function body
    * _Example of <ANY_PROCEDURAL_LANGUAGE>:_ `plpgsql`, `plpython`, ...
  * `as $$ <FUNCTION_BODY> $$`
    * `$$`
      * == function wrapper
    * `<FUNCTION_BODY>`
      * if you want a final `select` statement | function body, is returned -> you need NO statements / follow it

* steps to use a function
  * create it
  * execute it

* ways of "executing" the function
  * -- via -- SQL
  * -- via -- client libraries
    * JS
    * Dart
    * Swift
    * Kotlin
    * Python

## Returning data sets

* allows
  * apply filters & selectors
    * -- via -- SQL
    * -- via -- client libraries
      * JS
      * Dart
      * Swift
      * Kotlin
      * Python

## Passing parameters

* == execute a function / accepts parameters
  * ways
    * -- via -- SQL
    * -- via -- client libraries
      * JS
      * Dart
      * Swift
      * Kotlin
      * Python

## Suggestions

### Database Functions vs Edge Functions

For data-intensive operations, use Database Functions, which are executed within your database
and can be called remotely using the [REST and GraphQL API](../api).

For use-cases which require low-latency, use [Edge Functions](../../guides/functions), which are globally-distributed and can be written in Typescript.

### Security `definer` vs `invoker`

Postgres allows you to specify whether you want the function to be executed 
as the user _calling_ the function (`invoker`), or as the _creator_ of the function (`definer`)

It is best practice to use `security invoker` (which is also the default)
* If you ever use `security definer`, you _must_ set the `search_path`.
If you use an empty search path (`search_path = ''`), you must explicitly state the schema for every relation in the function body (e.g
* `from public.table`).
This limits the potential damage if you allow access to schemas which the user executing the function should not have.

### Function privileges

By default, database functions can be executed by any role
* There are two main ways to restrict this:

1.  On a case-by-case basis. Specifically revoke permissions for functions you want to protect. Execution needs to be revoked for both `public` and the role you're restricting:

    ```sql
    revoke execute on function public.hello_world from public;
    revoke execute on function public.hello_world from anon;
    ```

1.  Restrict function execution by default. Specifically _grant_ access when you want a function to be executable by a specific role.

    To restrict all existing functions, revoke execution permissions from both `public` _and_ the role you want to restrict:

    ```sql
    revoke execute on all functions in schema public from public;
    revoke execute on all functions in schema public from anon, authenticated;
    ```

    To restrict all new functions, change the default privileges for both `public` _and_ the role you want to restrict:

    ```sql
    alter default privileges in schema public revoke execute on functions from public;
    alter default privileges in schema public revoke execute on functions from anon, authenticated;
    ```

    You can then regrant permissions for a specific function to a specific role:

    ```sql
    grant execute on function public.hello_world to authenticated;
    ```

### Debugging functions

You can add logs to help you debug functions. This is especially recommended for complex functions.

Good targets to log include:

- Values of (non-sensitive) variables
- Returned results from queries

#### General logging

To create custom logs in the [Dashboard's Postgres Logs](/dashboard/project/_/logs/postgres-logs), you can use the `raise` keyword. By default, there are 3 observed severity levels:

- `log`
- `warning`
- `exception` (error level)

```sql
create function logging_example(
  log_message text,
  warning_message text,
  error_message text
)
returns void
language plpgsql
as $$
begin
  raise log 'logging message: %', log_message;
  raise warning 'logging warning: %', warning_message;

  -- immediately ends function and reverts transaction
  raise exception 'logging error: %', error_message;
end;
$$;

select logging_example('LOGGED MESSAGE', 'WARNING MESSAGE', 'ERROR MESSAGE');
```

#### Error handling

You can create custom errors with the `raise exception` keywords.

A common pattern is to throw an error when a variable doesn't meet a condition:

```sql
create or replace function error_if_null(some_val text)
returns text
language plpgsql
as $$
begin
  -- error if some_val is null
  if some_val is null then
    raise exception 'some_val should not be NULL';
  end if;
  -- return some_val if it is not null
  return some_val;
end;
$$;

select error_if_null(null);
```

Value checking is common, so Postgres provides a shorthand: the `assert` keyword. It uses the following format:

```sql
-- throw error when condition is false
assert <some condition>, 'message';
```

Below is an example

```sql
create function assert_example(name text)
returns uuid
language plpgsql
as $$
declare
  student_id uuid;
begin
  -- save a user's id into the user_id variable
  select
    id into student_id
  from attendance_table
  where student = name;

  -- throw an error if the student_id is null
  assert student_id is not null, 'assert_example() ERROR: student not found';

  -- otherwise, return the user's id
  return student_id;
end;
$$;

select assert_example('Harry Potter');
```

Error messages can also be captured and modified with the `exception` keyword:

```sql
create function error_example()
returns void
language plpgsql
as $$
begin
  -- fails: cannot read from nonexistent table
  select * from table_that_does_not_exist;

  exception
      when others then
          raise exception 'An error occurred in function <function name>: %', sqlerrm;
end;
$$;
```

#### Advanced logging

For more complex functions or complicated debugging, try logging:

- Formatted variables
- Individual rows
- Start and end of function calls

```sql
create or replace function advanced_example(num int default 10)
returns text
language plpgsql
as $$
declare
    var1 int := 20;
    var2 text;
begin
    -- Logging start of function
    raise log 'logging start of function call: (%)', (select now());

    -- Logging a variable from a SELECT query
    select
      col_1 into var1
    from some_table
    limit 1;
    raise log 'logging a variable (%)', var1;

    -- It is also possible to avoid using variables, by returning the values of your query to the log
    raise log 'logging a query with a single return value(%)', (select col_1 from some_table limit 1);

    -- If necessary, you can even log an entire row as JSON
    raise log 'logging an entire row as JSON (%)', (select to_jsonb(some_table.*) from some_table limit 1);

    -- When using INSERT or UPDATE, the new value(s) can be returned
    -- into a variable.
    -- When using DELETE, the deleted value(s) can be returned.
    -- All three operations use "RETURNING value(s) INTO variable(s)" syntax
    insert into some_table (col_2)
    values ('new val')
    returning col_2 into var2;

    raise log 'logging a value from an INSERT (%)', var2;

    return var1 || ',' || var2;
exception
    -- Handle exceptions here if needed
    when others then
        raise exception 'An error occurred in function <advanced_example>: %', sqlerrm;
end;
$$;

select advanced_example();
```

## Deep dive

### Create Database Functions

<div className="video-container">
  <iframe
    src="https://www.youtube-nocookie.com/embed/MJZCCpCYEqk"
    frameBorder="1"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowFullScreen
  ></iframe>
</div>

### Call Database Functions using JavaScript

<div className="video-container">
  <iframe
    src="https://www.youtube-nocookie.com/embed/I6nnp9AINJk"
    frameBorder="1"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowFullScreen
  ></iframe>
</div>

### Using Database Functions to call an external API

<div className="video-container">
  <iframe
    src="https://www.youtube-nocookie.com/embed/rARgrELRCwY"
    frameBorder="1"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowFullScreen
  ></iframe>
</div>
