---
id: 'local-development-testing-overview'
title: 'Testing Overview'
description: 'Learn how to develop and test database schemas, tables, functions, and Row Level Security (RLS) policies.'
---

* Testing
  * critical part of database development
    * ESPECIALLY working with RLS policies

* goal
  * how to test your Supabase database

## Testing approaches

### Database unit testing -- with -- pgTAP

* [pgTAP](https://pgtap.org)
  * == unit testing framework -- for -- Postgres 
    * allows testing
      * Database structure: tables, columns, constraints
      * RLS policies
      * Functions and procedures
      * Data integrity

* steps
  * `supabase test new <TEST_DESCRIPTION.test>`
  * | "TEST_DESCRIPTION.test",
    * write your tests
  * `supabase test db`

* **Test Data Setup**
  * if you want to ensure test isolation -> begin and rollback
  * create realistic test data / covers edge cases
  * use
    * DIFFERENT user roles | tests &
    * DIFFERENT permissions | tests

### Application-Level testing

* application-level tests
  * == write tests / interface -- with -- a Supabase client instance
    * ALLOWED to
      * use the programming language(s) == programming language / used | your application
      * use your favorite testing framework
  * vs database-level testing
    * ❌can NOT use transactions -- for -- isolation❌
  * ❌should NOT rely -- on -- a clean database state❌
    * Reason:🧠reset the database BEFORE EACH test, can 
      * be slow
      * make tests DIFFICULT to PARALELLIZE🧠
  * SOLUTION: 🧠design your tests / are -- , by using UNIQUE UID / EACH test case, -- independent🧠

* **RLS Policy Testing**
  * Test
    * Create/Read/Update/Delete operations
    * DIFFERENT user roles
      * anonymous
      * authenticated
    * edge cases
    * potential security bypasses
    * negative cases
      * == what users should NOT be able to do

#### Test isolation strategies

* ways to get test isolation
  1. **UNIQUE Identifiers**
     * == generate UIDs / EACH test suite
       * benefits
         * prevent data conflicts
  2. **AFTER Tests, cleanup**
     * == `afterAll` hook OR `afterEach` hook
  3. **Isolated Data Sets**
     * == separate test cases -- by -- using prefixes or namespaces | data 

### CI testing

* steps
  * `touch .github/workflows/db-tests.yml`

    ```yaml
    name: Database Tests
    
    on:
      push:
        branches: [main]
      pull_request:
        branches: [main]
    
    jobs:
      test:
        runs-on: ubuntu-latest
    
        steps:
          - uses: actions/checkout@v4
    
          - name: Setup Supabase CLI
            uses: supabase/setup-cli@v1
    
          - name: Start Supabase
            run: supabase start
    
          - name: Run Tests
            run: supabase test db
    ```

* recommendations
  * run tests AUTOMATICALLY / EACH pull request
  * | CD pipeline, 
    * add database tests
  * test runs -- , via transactions, -- fast

## Real-World examples

* [Database Tests Example Repository](https://github.com/usebasejump/basejump/tree/main/supabase/tests/database)
* [RLS Guide and Best Practices](https://github.com/orgs/supabase/discussions/14576)

## Troubleshooting

* PROBLEMS
  * PROBLEM1: **Test Failures Due to RLS**
    * ATTEMPTS
      * check
        * `set local role authenticated;`
        * `set local "request.jwt.claims"`
        * policy definitions match your test assumptions
  * PROBLEM2: **CI Pipeline Issues**
    * ATTEMPTS
      * check
        * Supabase CLI is PROPERLY installed
        * database migrations are run BEFORE tests
        * proper test isolation -- via -- transactions
