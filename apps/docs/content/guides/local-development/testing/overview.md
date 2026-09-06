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

TODO:


This example demonstrates setting up and testing RLS policies for a basic todo application:

2. Set up your testing environment:

   ```bash
   # Create a new test for our policies using supabase cli
   supabase test new todos_rls.test
   ```

3. Write your RLS tests:

   ```sql
   begin;
   -- install tests utilities
   -- install pgtap extension for testing
   create extension if not exists pgtap with schema extensions;
   -- Start declare we'll have 4 test cases in our test suite
   select plan(4);

   -- Setup our testing data
   -- Set up auth.users entries
   insert into auth.users (id, email) values
   	('123e4567-e89b-12d3-a456-426614174000', 'user1@test.com'),
   	('987fcdeb-51a2-43d7-9012-345678901234', 'user2@test.com');

   -- Create test todos
   insert into public.todos (task, user_id) values
   	('User 1 Task 1', '123e4567-e89b-12d3-a456-426614174000'),
   	('User 1 Task 2', '123e4567-e89b-12d3-a456-426614174000'),
   	('User 2 Task 1', '987fcdeb-51a2-43d7-9012-345678901234');

   -- as User 1
   set local role authenticated;
   set local request.jwt.claim.sub = '123e4567-e89b-12d3-a456-426614174000';

   -- Test 1: User 1 should only see their own todos
   select results_eq(
   	'select count(*) from todos',
   	ARRAY[2::bigint],
   	'User 1 should only see their 2 todos'
   );

   -- Test 2: User 1 can create their own todo
   select lives_ok(
   	$$insert into todos (task, user_id) values ('New Task', '123e4567-e89b-12d3-a456-426614174000'::uuid)$$,
   	'User 1 can create their own todo'
   );

   -- as User 2
   set local request.jwt.claim.sub = '987fcdeb-51a2-43d7-9012-345678901234';

   -- Test 3: User 2 should only see their own todos
   select results_eq(
   	'select count(*) from todos',
   	ARRAY[1::bigint],
   	'User 2 should only see their 1 todo'
   );

   -- Test 4: User 2 cannot modify User 1's todo
   SELECT results_ne(
   	$$ update todos set task = 'Hacked!' where user_id = '123e4567-e89b-12d3-a456-426614174000'::uuid returning 1 $$,
   	$$ values(1) $$,
   	'User 2 cannot modify User 1 todos'
   );

   select * from finish();
   rollback;
   ```

4. Run the tests:

   ```bash
   supabase test db
   psql:todos_rls.test.sql:4: NOTICE:  extension "pgtap" already exists, skipping
   ./todos_rls.test.sql .. ok
   All tests successful.
   Files=1, Tests=6,  0 wallclock secs ( 0.01 usr +  0.00 sys =  0.01 CPU)
   Result: PASS
   ```

### Application-Level testing

* application-level tests
  * vs database-level testing
    * ❌can NOT use transactions -- for -- isolation❌
  * ❌should NOT rely -- on -- a clean database state❌
    * Reason:🧠reset the database BEFORE EACH test, can 
      * be slow
      * make tests DIFFICULT to PARALELLIZE🧠
  * SOLUTION: 🧠design your tests / are -- , by using UNIQUE UID / EACH test case, -- independent🧠

#### Test isolation strategies

TODO: 

For application-level testing, consider these approaches for test isolation:

1. **Unique Identifiers**: Generate unique IDs for each test suite to prevent data conflicts
2. **Cleanup After Tests**: If necessary, clean up created data in an `afterAll` or `afterEach` hook
3. **Isolated Data Sets**: Use prefixes or namespaces in data to separate test cases

### Continuous integration testing

Set up automated database testing in your CI pipeline:

1. Create a GitHub Actions workflow `.github/workflows/db-tests.yml`:

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

## Best practices

1. **Test Data Setup**
   - Use begin and rollback to ensure test isolation
   - Create realistic test data that covers edge cases
   - Use different user roles and permissions in tests

2. **RLS Policy Testing**
   - Test Create, Read, Update, Delete operations
   - Test with different user roles: anonymous and authenticated
   - Test edge cases and potential security bypasses
   - Always test negative cases: what users should not be able to do

3. **CI/CD Integration**
   - Run tests automatically on every pull request
   - Include database tests in deployment pipeline
   - Keep test runs fast using transactions

## Real-World examples

* [Database Tests Example Repository](https://github.com/usebasejump/basejump/tree/main/supabase/tests/database)
* [RLS Guide and Best Practices](https://github.com/orgs/supabase/discussions/14576)

## Troubleshooting

Common issues and solutions:

1. **Test Failures Due to RLS**
   - Ensure you've set the correct role `set local role authenticated;`
   - Verify JWT claims are set `set local "request.jwt.claims"`
   - Check policy definitions match your test assumptions

2. **CI Pipeline Issues**
   - Verify Supabase CLI is properly installed
   - Ensure database migrations are run before tests
   - Check for proper test isolation using transactions

## Additional resources

- [pgTAP Documentation](https://pgtap.org)
- [Supabase CLI Reference](/docs/reference/cli/supabase-test)
- [pgTAP Supabase reference](/docs/guides/database/extensions/pgtap?queryGroups=database-method&database-method=sql#testing-rls-policies)
- [Database testing reference](/docs/guides/database/testing)
