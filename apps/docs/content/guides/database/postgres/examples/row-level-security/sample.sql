-- 1. create policy
create policy "Individuals can view their own todos."
on todos for select
using ( (select auth.uid()) = user_id );

-- ==
-- select *
-- from todos
-- where auth.uid() = todos.user_id;

-- 2. enable RLS
alter table "table_name" enable row level security;

-- 3. create an event trigger / runs AFTER table creation
CREATE OR REPLACE FUNCTION rls_auto_enable()
RETURNS EVENT_TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog
AS $$
DECLARE
cmd record;
BEGIN
FOR cmd IN
SELECT *
FROM pg_event_trigger_ddl_commands()
WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
  AND object_type IN ('table','partitioned table')
    LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
BEGIN
EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
END;
ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
END IF;
END LOOP;
END;
$$;

DROP EVENT TRIGGER IF EXISTS ensure_rls;
CREATE EVENT TRIGGER ensure_rls
ON ddl_command_end
WHEN TAG IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
EXECUTE FUNCTION rls_auto_enable();

-- X.
-- X.1 SELECT policies
       -- 1. Create table | public schema
create table profiles (
                          id uuid primary key,
                          user_id uuid references auth.users,
                          avatar_url text
);

        -- 2. Enable RLS
alter table profiles enable row level security;

        -- 3. Policies
        -- 3.1 Create Policy / enable read access | everyone
create policy "Public profiles are visible to everyone."
on profiles for select
       to anon         -- the Postgres Role (recommended)
       using ( true ); -- the actual Policy
        -- 3.2 Create Policy / ONLY OWN users can see their OWN profiles
create policy "User can see their own profile only."
on profiles
for select using ( (select auth.uid()) = user_id );

-- X.2 INSERT policies
        -- X.2.1 Create table | public schema
create table profiles (
                          id uuid primary key,
                          user_id uuid references auth.users,
                          avatar_url text
);

        -- X.2.2 Enable RLS
alter table profiles enable row level security;

        -- X.2.3 Create Policy /
        --      ONLY users can create a profile -- for -- themselves
create policy "Users can create a profile."
on profiles for insert
to authenticated                          -- the Postgres Role (recommended)
with check ( (select auth.uid()) = user_id );      -- the actual Policy

-- X.3 UPDATE policies
       -- X.3.1 Create a table | public schema
       --      ONLY users can update their OWN profile
create table profiles (
                          id uuid primary key,
                          user_id uuid references auth.users,
                          avatar_url text
);

       -- X.3.2. Enable RLS
alter table profiles enable row level security;

       -- X.3.3. Create Policy
create policy "Users can update their own profile."
on profiles for update
                           to authenticated                    -- the Postgres Role (recommended)
                           using ( (select auth.uid()) = user_id )       -- checks if the existing row complies with the policy expression
                with check ( (select auth.uid()) = user_id ); -- checks if the new row complies with the policy expression

-- X.4 DELETE policies


-- Y. Helper functions

-- Y.3 MFA
--      users can update their OWN profile ONLY if they have 2 2 levels of authentication                                                                -
create policy "Restrict updates."
on profiles
as restrictive
for update
               to authenticated using (
               (select auth.jwt()->>'aal') = 'aal2'
               );