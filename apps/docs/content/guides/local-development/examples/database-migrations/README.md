* goal
  * create a table / name: `employees` + check how to make changes | it

# prerequisites

* TODO:
* `supabase start`

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

# Diffing changes

* steps
  * | Supabase Dashboard > Table editor > create "cities" table / 's columns: `id`, `name` and `population`
  * `supabase db diff --schema public`
    * 's output: SQL
  * `touch supabase/migrations/citiesdiffing.sql`
    * past PREVIOUS output content
  * `supabase db reset`
    * reset db -- from -- migration files

# Deploy your project

TODO:
