---
id: 'testing-emails-locally'
title: 'Testing and linting'
description: 'Using the CLI to test your Supabase project.'
subtitle: 'Using the CLI to test your Supabase project.'
---

## Testing your database

* `supabase test db`
  * allows
    * linting Postgres

* powered -- by -- the [pgTAP extension](../../database/extensions/pgtap)
* [how to write & run tests | your database](../../database/testing)

### Test helpers

TODO: 
Our friends at [Basejump](https://usebasejump.com/) have created a useful set of Database [Test Helpers](https://github.com/usebasejump/supabase-test-helpers), with an accompanying [blog post](https://usebasejump.com/blog/testing-on-supabase-with-pgtap).

### Running database tests in CI

Use our GitHub Action to [automate your database tests](/docs/guides/deployment/ci/testing).

## Testing your Edge Functions

Edge Functions are powered by Deno, which provides a [native set of testing tools](https://deno.land/manual@v1.35.3/basics/testing)
* We extend this functionality in the Supabase CLI
* You can find a detailed guide in the [Edge Functions section](/docs/guides/functions/unit-test).

## how to test Auth emails?

* -- thanks to -- [Mailpit](https://github.com/axllent/mailpit)
* allows
  * capturing emails / 
    * sent -- from -- your local machine
* use cases
  * test emails /
    * sent -- from -- Supabase Auth

### how to access Mailpit?

* ⚠️requirements⚠️
  * `supabase start`
* by default, 
  * localhost:54324

### | production

* steps
  * configure your OWN email provider | [project settings](../../auth/auth-smtp.md)
    * Reason:🧠Mailtip is ONLY valid -- for -- development purposes🧠
    * [MORE](../../deployment/going-into-prod.md)

## Linting your database

TODO: 
The Supabase CLI provides Postgres linting using the `supabase db lint` command:

{/* prettier-ignore */}
```markdown
supabase db lint --help
Checks local database for typing error

Usage:
  supabase db lint [flags]

Flags:
  --level [ warning | error ] Error level to emit. (default warning)
  --linked Lints the linked project for schema errors.
  -s, --schema strings List of schema to include. (default all)
```

This is powered by [plpgsql_check](https://github.com/okbob/plpgsql_check), which leverages the internal Postgres parser/evaluator so you see any errors that would occur at runtime
* It provides the following features:

- validates you are using the correct types for function parameters
- identifies unused variables and function arguments
- detection of dead code (any code after an `RETURN` command)
- detection of missing `RETURN` commands with your Postgres function
- identifies unwanted hidden casts, which can be a performance issue
- checks `EXECUTE` statements against SQL injection vulnerability

Check the Reference Docs for [more information](/docs/reference/cli/supabase-db-lint).
