## Project setup

* goal
  * set up the
    * Database
    * API

* steps
  * [start a NEW Project | Supabase](#create-a-project)
  * [create a "schema" | database](#create-a-project)

### Create a project

1. | [Supabase Dashboard](dash),
   * create a NEW project
   * Enter your project details
   * -> NEW database is launched

### Set up the database schema

TODO:

Now set up the database schema. You can use the "User Management Starter" quickstart in the SQL Editor, or you can copy/paste the SQL from below and run it.

<Tabs
  scrollable
  size="small"
  type="underlined"
  defaultActiveId="dashboard"
  queryGroup="database-method"
>
<TabPanel id="dashboard" label="Dashboard">

1. Go to the [SQL Editor](/dashboard/project/_/sql) page in the Dashboard.
2. Click **User Management Starter** under the **Community > Quickstarts** tab.
3. Click **Run**.

<Admonition type="note">

You can pull the database schema down to your local project by running the `db pull` command. Read the [local development docs](/docs/guides/cli/local-development#link-your-project) for detailed instructions.

```bash
supabase link --project-ref <project-id>
# You can get <project-id> from your project's dashboard URL: https://supabase.com/dashboard/project/<project-id>
supabase db pull
```

</Admonition>

</TabPanel>
<TabPanel id="sql" label="SQL">

<Admonition type="note">

When working locally you can run the following command to create a new migration file:

</Admonition>

```bash
supabase migration new user_management_starter
```

<$Partial path="user_management_quickstart_sql_template.mdx" />

</TabPanel>
</Tabs>

<$Partial path="api_settings.mdx" variables={{ "framework": "{{ .framework }}", "tab": "{{ .tab }}" }}
/>
