---
id: 'testing'
title: 'Testing Your Database'
description: 'Test your database schema, tables, functions, and policies.'
---

* approaches to testing
  * [application level testing](../local-development/testing/overview.md) 
  * [-- via -- Supabase CLI](#---via----supabase-cli)

## -- via -- Supabase CLI

* == low-level approach
* == write tests | SQL

* requirements
  * ⚠️install Supabase CLI v1.11.4+⚠️

### Creating a test

* steps
  * `mkdir -p ./supabase/tests/database`
  * `touch ./supabase/tests/database/<FILE_NAME>.test.sql`

### Writing tests

* [pgTAP](extensions/pgtap)
  * == test runner -- for -- "*.test.sql"

* | "*.test.sql"
  * add sql test

### how to run tests?

* steps
  * `supabase test db`
    * print the testing output

### More resources

* [how to test RLS -- via -- pgTAP + dbdev](https://github.com/usebasejump/supabase-test-helpers/tree/main)