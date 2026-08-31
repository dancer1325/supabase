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

* steps
  * | "supabase/seed.sql",
    * add SQL content
  * `supabase db reset`
    * allows
      * reset your database
      * reapply migrations
      * populate -- with -- seed data

### Diffing changes

* ⚠️ALTERNATIVE TO⚠️
  * Supabase Dashboard

* allows
  * generate -- , by diffing your schema changes vs EXISTING "supabase/migrations/" , -- "*.sql"

* ⚠️| modify schema changes,
  * choose 1 BETWEEN "supabase/migraitons/*.sql" & modify DIRECTLY | Supabase Dashboard > SQL editor OR Table Editor⚠️
    * Reason:🧠OTHERWISE, break the migration history🧠

* steps
  * `supabase db diff -f <DIFF_CHANGE_NAME>`
    * create a NEW migration file "supabase/migrations/<timestamp>_DIFF_CHANGE_NAME.sql"
  * `supabase db reset`
    * test your NEW migration file -- by -- resetting your LOCAL database

## Deploy your project

TOO: 

You've been developing your project locally, making changes to your tables via migrations
* It's time to deploy your project to the Supabase Platform and start scaling up to millions of users!

Head over to [Supabase](/dashboard) and create a new project to deploy to.

### 1. Log in to the Supabase CLI

[Login](/docs/reference/cli/supabase-login) to the Supabase CLI using an auto-generated Personal Access Token.

```bash
supabase login
```

### 2. Link your project

[Link](/docs/reference/cli/supabase-link) to your remote project by selecting from the on-screen prompt.

```bash
supabase link
```

### 3. Deploy database migrations

[Push](/docs/reference/cli/supabase-db-push) your migrations to the remote database.

```bash
supabase db push
```

### 4. Deploy database seed data (optional)

[Push](/docs/reference/cli/supabase-db-push) your migrations and seed the remote database.

```bash
supabase db push --include-seed
```

Visiting your live project on [Supabase](/dashboard/project/_), you'll see a new `employees` table, complete with the `department` column you added in the second migration above.

## Working with a team

When multiple developers share a Supabase project, a few rules keep migrations from getting out of sync.

**The golden rule: never change the remote database directly.** Once you're using migrations, all schema changes — even small ones — should go through migration files
* Using the Dashboard's SQL editor or Table Editor on your remote database bypasses the migration history, and `db push` will start failing with sync errors.

**The team workflow:**

### 1. Create a migration locally

Each developer creates migration files on their own branch, never touching the remote database directly.

```bash
supabase migration new your_change_description
```

### 2. Test and commit

Reset your local database to apply the migration, then commit the migration file to git.

```bash
supabase db reset
git add supabase/migrations
git commit -m "add migration: your_change_description"
```

### 3. Pull and reset when a teammate merges a migration

After pulling new migration files from git, reset your local database to apply them.

```bash
git pull
supabase db reset
```

### 4. One person deploys to remote

Coordinate so only one person runs `db push` at a time
* Migration files are applied in timestamp order, so concurrent pushes from different machines can cause conflicts.

```bash
supabase db push
```

> 💡 For a more automated deployment approach, consider using [Supabase Branching](/docs/guides/deployment/branching) or a CI/CD pipeline that runs `supabase db push` on merge to your main branch.

## Diagnosing and fixing sync errors

If `db push` fails with errors suggesting you run `supabase migration repair`, your local migration files and the remote database's migration history are out of sync
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
