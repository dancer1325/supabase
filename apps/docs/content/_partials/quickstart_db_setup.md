```bash
export const sqlSetup = `-- Create the table
create table instruments (
  id bigint primary key generated always as identity,
  name text not null
);

-- Insert sample data into the table
insert into instruments (name)
values
('violin'),
('viola'),
('cello');

-- Grant the privileges the role needs, which is read access
grant select on public.instruments to anon;

-- Enable row level security for the table
alter table instruments enable row level security;

-- Create a policy to allow the anon role to read from the instruments table
create policy "public can read instruments"
on public.instruments
for select to anon
using (true);`
```

## 1. Create a Supabase project

* ways
  * -- via -- Supabase dashboard
  * -- via -- [Supabase Management API](../../spec/api_v1_openapi.json)
  * -- via -- [Supabase MCP server](../guides/ai-tools/mcp.md#account-management)

## 2. Set up your database

TODO: 
* Then set only the privileges each Postgres role needs, add [Row Level Security (RLS)](/docs/guides/database/postgres/row-level-security) 
for enhanced security for database data by default, and
create an RLS policy to make the data in the table publicly readable.

* ways to set up your DDBB
  * | your Supabase project's SQL Editor

  ```sql SQL_EDITOR
  -- Create the table
  create table instruments (
    id bigint primary key generated always as identity,
    name text not null
  );
  
  -- Insert sample data into the table
  insert into instruments (name)
  values
    ('violin'),
    ('viola'),
    ('cello');
  
  -- Grant the privileges the role needs, which is read access
  grant select on public.instruments to anon;
  
  -- Enable row level security for the table
  alter table instruments enable row level security;
  
  -- Create a policy to allow the anon role to read from the instruments table
  create policy "public can read instruments"
  on public.instruments
  for select to anon
  using (true);
  ```

  * -- via -- [POST /v1/projects/{ref}/database/query](../../spec/api_v1_openapi.json)
  * -- via -- [the MCP server](../guides/ai-tools/mcp.md#account-management)



<Admonition type="note" label="Disabled the Data API during project setup?">

If you disabled the Data API during project setup, enable it in the [**Integrations > Data API**](/dashboard/project/_/integrations/data_api/settings) 
section of the Dashboard and expose the specific tables or functions you want to access
* To automatically grant access for new tables and functions in `public`, enable **Automatically expose new tables**.

</Admonition>
