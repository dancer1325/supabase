* goal
  * create a table / name: `employees` + check how to make changes | it

# prerequisites
* download Docker Desktop
* `npx supabase init` OR `supabase init`
* `npx supabase start` OR `supabase start`

# Database migrations

* steps
  * `supabase migration new create_employees_table`
    * generates "supabase/migrations/<timestamp_create_employees_table>"
  * | "supabase/migrations/<timestamp>_create_employees_table",
    * add SQL content / create NEW table
  * `supabase db reset`
    * reset the database -- to the -- CURRENT migrations
    * run [SQL](sample.sql)
  * `supabase migration new add_department_to_employees_table`
  * | "supabase/migrations/<timestamp>_add_department_to_employees_table",
    * add SQL content / create NEW table
  * `supabase db reset`
    * run [SQL](sample.sql)

## Diffing changes

* steps
  * | Supabase Dashboard > Table editor > create "cities" table / 's columns: `id`, `name` and `population`
  * `supabase db diff --schema public`
    * 's output: SQL
  * `touch supabase/migrations/citiesdiffing.sql`
    * past PREVIOUS output content
  * `supabase db reset`
    * reset db -- from -- migration files

# Deploy your project
## Log in | Supabase CLI
TODO:
## link your local project -- with -- your remote project
TODO:
### `supabase link --project-ref <project-id>`
TODO:
### `supabase db pull` - pull remote `public` schema's changes NOT in local migrations
TODO:
### `supabase db reset`
TODO:
## Deploy database changes
TODO:
## Deploy Edge Functions
TODO:
## Use Auth LOCALLY
TODO:
### configure `[auth.external.*]` | "supabase/config.toml"
TODO:
### place secrets | ".env"
TODO:
### `supabase db pull --schema auth`
TODO:
### `supabase stop` & `supabase start` -- to -- apply changes
TODO:
## Sync storage buckets
TODO:
### `supabase db pull --schema storage` - pull RLS policies | storage buckets
TODO:
### buckets & objects == rows | storage tables
TODO:
### ways to define buckets
TODO:
#### -- via -- Supabase Storage API
TODO:
#### | "supabase/config.toml" - `[storage.buckets.bucket_name.*]`
TODO:
#### ❌NOT via SQL❌
TODO:
### steps to sync locally
TODO:
#### configure `[storage.buckets.bucket_name.*]` | "supabase/config.toml"
TODO:
#### place your files | "supabase/<bucket_name>"
TODO:
#### `supabase seed buckets`
TODO:
## Sync any schema -- with -- `--schema`
TODO:
### `supabase db pull --schema <schema_name>`
TODO:
### PROBLEM: if "supabase/migrations/" is empty -> `--schema` is ignored
TODO:
#### SOLUTION: pull twice
TODO:
