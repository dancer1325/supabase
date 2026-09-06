---
id: 'database-migrations'
title: 'Database migrations'
description: 'Track and version your database schema changes with migrations.'
subtitle: 'Track and version your database schema changes with migrations.'
video: 'https://www.youtube-nocookie.com/v/vyHyYpvjaks'
tocVideo: 'vyHyYpvjaks'
---

* goal
  * database migrations

* ways to manage migrations LOCALLY
  * make changes | integrated Studio Dashboard + capture your changes | schema migration files
    * schema migration files
      * can be versioned
  * write your OWN migration files & SQL + push them | local database

## Database migrations

* Database migrations
  * allows
    * tracking database changes | time 
  * [video](https://www.youtube-nocookie.com/embed/Kx5nHBmIxyQ)
    * TODO:

* steps
  * `supabase migration new <MIGRATION_FILE_NAME>`
    * generate a NEW migration file | "supabase/migrations/"
  * | PREVIOUS generated migration file | "supabase/migrations/"
    * add the SQL content -- about -- the migration
  * `supabase db reset`
    * 💡execute the "supabase/migrations/*.sql"💡

* ⚠️check vs [deployment's database migrations' steps](../deployment/database-migrations.md) ⚠️

### Seeding data / EACH reset of the database

* steps
  * | "supabase/seed.sql",
    * add SQL content
  * `supabase db reset`
    * allows
      * reset your database
      * reapply migrations
      * populate -- with -- seed data

### Diffing changes

* use cases
  * you create SQL | Supabase Dashboard
    * -> ⚠️you need to create your migration files⚠️

* allows
  * generate -- , by diffing your CURRENT schema vs EXISTING "supabase/migrations/" , -- "*.sql"

* ⚠️| modify schema changes,
  * choose 1 BETWEEN "supabase/migraitons/*.sql" & modify DIRECTLY | Supabase Dashboard > SQL editor OR Table Editor⚠️
    * Reason:🧠OTHERWISE, break the migration history🧠

* steps
  * `supabase db diff -f <DIFF_CHANGE_NAME>`
    * create a NEW migration file "supabase/migrations/<timestamp>_DIFF_CHANGE_NAME.sql"
  * `supabase db reset`
    * test your NEW migration file -- by -- resetting your LOCAL database

## Deploy your project

* goal
  * deploy your project | Supabase Platform

### Log in | Supabase CLI

```bash
# 1. -- via -- supabase CLI
supabase login

# 2. -- via -- npx
npx supabase login
```

### link your local project -- with -- your remote project

* steps
  * `supabase link --project-ref <project-id>`
    * `<project-id>`
      * found | Supabase Dashboard > choose the project > check URL
  * `supabase db pull`
    * pull remote `public` schema's database changes / are NOT | your local migrations
      * == create "supabase/migration/<timestamp>_remote_schema.sql"
    * 's goal
      * align local database -- & -- remote database
  * `supabase db reset`

### Deploy database changes | Supabase Cloud remote

```bash
supabase db push

# if you want to push the seed | remote database -> --include-seed 
supabase db push --include-seed
```

### Deploy Edge Functions

```bash
supabase functions deploy <function_name>
```

### Use Auth LOCALLY

* steps
  * | your project's "supabase/config.toml",
    * configure your desired `[auth.external.*]`

      ```toml
      # supabase/config.toml
      [auth.external.github]
      enabled = true
      client_id = "env(SUPABASE_AUTH_GITHUB_CLIENT_ID)"
      secret = "env(SUPABASE_AUTH_GITHUB_SECRET)"
      redirect_uri = "http://localhost:54321/auth/v1/callback"
      ```
      * place secrets | ".env"

        ```bash
        # .env
        SUPABASE_AUTH_GITHUB_CLIENT_ID="redacted"
        SUPABASE_AUTH_GITHUB_SECRET="redacted"
        ```
  * `supabase db pull --schema auth`
  * `supabase stop` & `supabase start`
    * Reason:🧠these changes take effect🧠

### Sync storage buckets

* if you want to pull locally your RLS policies | storage buckets -> `supabase db pull --schema storage`

* buckets & objects 
  * [Supabase Storage](../storage.md) == rows | storage tables
    * == `storage.buckets` & `storage.objects`
  * ways to define it
    * -- via -- Supabase Storage API
    * | "supabase/config.toml" file,
      * [`[storage.buckets.bucket_name.*]`](../../../spec/cli_v1_config.yaml)
        * uses
          * locally
  * ❌NO ways to define it❌
    * -- via -- SQL
      * Reason: 🧠NOT appear | your schema🧠

* steps to sync locally
  * | "supabase/config.toml" file, configure `[storage.buckets.bucket_name.*]`
  * place your files | "supabase/<bucket_name>"
  * `supabase seed buckets`

### Sync any schema -- with -- `--schema`

* if you want to synchronize your database with a SPECIFIC schema -> use `--schema` option

  ```bash
  supabase db pull --schema <schema_name>
  ```
  * PROBLEMS:
    * PROBLEM1: if your local "supabase/migrations/" is empty ->  `supabase db pull` ignore the `--schema` parameter
      * SOLUTION:

        ```bash
        supabase db pull
        supabase db pull --schema <schema_name>
        ```
