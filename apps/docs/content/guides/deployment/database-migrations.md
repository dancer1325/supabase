---
id: 'database-migrations'
title: 'Database Migrations'
description: 'How to manage schema migrations for your Supabase project.'
subtitle: 'How to manage schema migrations for your Supabase project.'
video: 'https://www.youtube-nocookie.com/v/Kx5nHBmIxyQ'
tocVideo: 'Kx5nHBmIxyQ'
---

* Database migrations
  * == SQL statements /
    * about your EXISTING database schemas
      * create
      * update
      * delete 
  * allows
    * tracking database changes | time

## Schema migrations

* requirements  
  * [install Supabase CLI](../local-development.md)
  * `supabase start`

* steps
  * `supabase migration new <MIGRATION_FILE_NAME>`
    * generate a NEW migration file | "supabase/migrations/"
  * | PREVIOUS generated migration file | "supabase/migrations/"
    * add the SQL content -- about -- the migration
  * `supabase migration up`
    * 💡execute the "supabase/migrations/*.sql"💡
    * ⚠️if a lock timeout error occurs -> increase [`lock_timeout` setting](https://postgresqlco.nf/doc/en/param/lock_timeout/) | your migration file⚠️
  * `supabase migration new add_name_column` 
  * | PREVIOUS "supabase/migrations/*.sql"
    * add the SQL content -- about -- the migration
  * `supabase migration up`
    * 💡execute the "supabase/migrations/*.sql"💡

### Seeding data / EACH reset of the database 

* [here](../local-development/database-migrations.md)

### Diffing changes

* [here](../local-development/database-migrations.md)

## Deploy your project

* [here](../local-development/database-migrations.md#deploy-your-project)

## Working >1 people

* use case
  * \>1 developers share a Supabase project

* how to change the remote database?
  * ❌NEVER change DIRECTLY the REMOTE database❌
  * ⚠️if you're using migrations -> ALL schema changes go -- through -- migration files⚠️
    * ways
      * steps / EACH developer
        * `supabase migration new <change_description>`
          * == creates "migration/<change_description>"
        * `supabase db reset`
          * == reset your local database 
        * `git add supabase/migrations` && `git commit -m "add migration: your_change_description"`
        * `git pull`
          * pull "migration/" -- from -- master
        * `supabase db reset`
        * ⚠️decide by the team / ONLY 1 guy runs `supabase db push`⚠️
          * Reason:🧠"migration/<FILE_NAME>" are applied | timestamp order🧠
      * AUTOMATED deployment approach
        * ways
          * [Supabase Branching](branching), OR
          * CI/CD pipeline / 
            * onMerge your main branch, run `supabase db push`

## Diagnosing and fixing sync errors

TODO:

If `db push` fails with errors suggesting you run `supabase migration repair`, 
your local migration files and the remote database's migration history are out of sync
* Here's how to diagnose and fix it.

### How migration tracking works

Supabase tracks which migrations have been applied on each database in a table called `supabase_migrations.schema_migrations`
* When you run `supabase db push`, it compares your local `supabase/migrations` folder against that table and runs only the ones not yet applied, in order.

Git tracks your migration _files_
* Supabase tracks what's been _applied to each database_
* These are two separate systems that need to stay in sync.

### Step 1: Check what's out of sync

Start by listing the migration status across local and remote:

```bash
supabase migration list
```

This shows which migrations are applied locally, which are applied on the remote, and where they diverge.

### Step 2: If you made changes on the remote database directly

Pull the current remote state into a migration file to get back in sync:

```bash
supabase db pull
```

This creates a new migration file capturing the current remote schema
* Commit it to git, then follow the standard workflow going forward.

### Step 3: If the migration history table is wrong

If a migration shows as missing in the remote history table but the schema change is already there (for example, it was applied manually), you can mark it as applied without re-running it:

```bash
supabase migration repair --status applied <migration-timestamp>
```

Or if a migration is recorded as applied but was never run:

```bash
supabase migration repair --status reverted <migration-timestamp>
```

> ⚠️ `migration repair` updates the tracking table only — it does not apply or revert any SQL
> * Use it to correct the history record when you know the actual database state is correct.
