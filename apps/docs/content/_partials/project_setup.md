## Project setup

* goal
  * set up the
    * Database
    * API

* steps
  * [start a NEW Project | Supabase](#create-a-project)
  * [create a "schema" | database](#create-a-project)

### Create a project

1. | Supabase Dashboard,
   * create a NEW project
   * Enter your project details
   * -> NEW database is launched

### Set up the database schema

* ways
  * [-- via -- "User Management Starter" quickstart | SQL Editor](#---via----user-management-starter-quickstart--sql-editor)
  * [-- via -- running the SQL ](#---via----running-the-sql)

#### -- via -- "User Management Starter" quickstart | SQL Editor

* steps
  1. | Dashboard > choose your project > SQL Editor
  2. Examples > User Management Starter** under the **Community > Quickstarts** tab.
  3. Click **Run**
  4. [pull the database schema down -- to -- your local project](../guides/local-development/database-migrations.md#link-your-project) 

    ```bash
    supabase link --project-ref <project-id>
    # You can get <project-id> from your project's dashboard URL: https://supabase.com/dashboard/project/<project-id>
    supabase db pull
    ```

#### -- via -- running the SQL

* use cases
  * locally

```bash
supabase migration new user_management_starter
```

* [user_management_quickstart_sql_template.md](user_management_quickstart_sql_template.md)
* [API settings](api_settings.md)
