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

### Deploy database changes

```bash
supabase db push
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

TODO: 
The buckets and objects themselves are rows in the storage tables so they won't appear in your schema
* You can instead define them via `supabase/config.toml` file
* For example,

```toml
# supabase/config.toml
[storage.buckets.images]
public = false
file_size_limit = "50MiB"
allowed_mime_types = ["image/png", "image/jpeg"]
objects_path = "./images"
```

This will upload files from `supabase/images` directory to a bucket named `images` in your project with one command.

```bash
supabase seed buckets
```

### Sync any schema with `--schema`

You can synchronize your database with a specific schema using the `--schema` option as follows:

```bash
supabase db pull --schema <schema_name>
```

> ⚠️ If the local `supabase/migrations` directory is empty, the `db pull` command will ignore the `--schema` parameter.
>
> To fix this, you can pull twice:
>
> ```bash
> supabase db pull
> supabase db pull --schema <schema_name>
> ```

## Limitations and considerations

The local development environment is not as feature-complete as the Supabase Platform
* Here are some of the differences:

- You cannot update your project settings in the Dashboard
* This must be done using the local config file.
- The CLI version determines the local version of Studio used, so make sure you keep your local [Supabase CLI up to date](https://github.com/supabase/cli#getting-started)
* We're constantly adding new features and bug fixes.
