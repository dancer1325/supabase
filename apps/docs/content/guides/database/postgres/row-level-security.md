---
id: 'row-level-security'
title: 'Row Level Security'
description: 'Secure your data using Postgres Row Level Security.'
subtitle: 'Secure your data using Postgres Row Level Security.'
---

* Postgres's [Row Level Security (RLS)](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
  * == Postgres primitive
  * allow
    * granular authorization rules
      * == write complex SQL rules / fit your unique business needs
  * provide
    * "[defense in depth](https://en.wikipedia.org/wiki/Defense_in_depth_(computing))" / protect your data -- from -- malicious actors
      * even | access -- through -- third-party tooling

## Row Level Security | Supabase

* requirements
  * ⚠️| ANY tables / stored | exposed schema, enable RLS⚠️ 
    * default exposed schema: `public` schema

* RLS
  * enable
    * default,
      * create the tables -- through -- Supadabase Dashboard > Table Editor
    * if you want to enable RLS yourself

      ```sql
      alter table <schema_name>.<table_name>
      enable row level security;
      ```

  * if it's enabled & you want to access data -- , through publishable key, to -- | [Supabase API](../../api) -> you need to create policies
  * \+ [Supabase Auth](../../auth) == E2E user security (browser -- to the -- database)
    * == | browser, you can access the data
      * conveniently
      * securely
  * if you want to 
    * enable it -> `alter table "table_name" enable row level security;`
    * [auto-enable it | NEW tables](#-new-tables-auto-enable-rls)

### | NEW tables, auto-enable RLS

* steps
  * create an [event trigger](event-triggers.md) / runs AFTER table creation
    * ❌NOT affect | EXISTING tables❌
      * == ⚠️you need to enable MANUALLY RLS⚠️

* recommendations
  * 👀EXPLICITLY checking for authentication👀

    ```sql
    USING (auth.uid() IS NOT NULL AND auth.uid() = user_id)
    ```
    * Reason:🧠
      * avoid confusion
      * make your intention clear
      * OTHERWISE, `USING (auth.uid() = user_id)`
        * requirest WITHOUT authenticated user -> auth.uid() = null -> fail🧠

### how to bypass RLS?

* ways to bypass RLS
  * Supabase's special "Service" keys
  * create NEW Postgres role / has `bypassrls` privilege

    ```sql
    alter role "role_name" with bypassrls;
    ```

* Supabase's special "Service" keys
  * ❌NOT uses❌
    * | browser
  * use cases
    * administrative tasks
  * if the client library is initialized with a Service Key -> Supabase adheres to the signed-in user's RLS policy

* Postgres role / has `bypassrls` privilege
  * use cases
    * system-level access
  * recommendations
    * ❌NEVER share Postgres role's login credentials❌

### RLS performance recommendations

TODO: 
Every authorization system has an impact on performance
* While row level security is powerful, the performance impact is important to keep in mind
* This is especially true for queries that scan every row in a table - like many `select` operations, including those using limit, offset, and ordering.

Based on a series of [tests](https://github.com/GaryAustin1/RLS-Performance), we have a few recommendations for RLS:

#### Add indexes

Make sure you've added [indexes](/docs/guides/database/postgres/indexes) on any columns used within the Policies which are not already indexed (or primary keys)
* For a Policy like this:

```sql
create policy "rls_test_select" on test_table
to authenticated
using ( (select auth.uid()) = user_id );
```

You can add an index like:

```sql
create index userid
on test_table
using btree (user_id);
```

##### Benchmarks

| Test                                                                                          | Before (ms) | After (ms) | % Improvement | Change                                                                                                   |
| --------------------------------------------------------------------------------------------- | ----------- | ---------- | ------------- | -------------------------------------------------------------------------------------------------------- |
| [test1-indexed](https://github.com/GaryAustin1/RLS-Performance/tree/main/tests/test1-indexed) | 171         | < 0.1      | 99.94%        | <details className="cursor-pointer">Before:<br/>No index<br/><br/>After:<br/>`user_id` indexed</details> |

#### Call functions with `select`

You can use `select` statement to improve policies that use functions
* For example, instead of this:

```sql
create policy "rls_test_select" on test_table
to authenticated
using ( auth.uid() = user_id );
```

You can do:

```sql
create policy "rls_test_select" on test_table
to authenticated
using ( (select auth.uid()) = user_id );
```

This method works well for JWT functions like `auth.uid()` and `auth.jwt()` as well as `security definer` Functions
* Wrapping the function causes an `initPlan` to be run by the Postgres optimizer, which allows it to "cache" the results per-statement, rather than calling the function on each row.

> ⚠️ You can only use this technique if the results of the query or function do not change based on the row data.

##### Benchmarks

| Test                                                                                                                              | Before (ms) | After (ms) | % Improvement | Change                                                                                                                                                                    |
| --------------------------------------------------------------------------------------------------------------------------------- | ----------- | ---------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [test2a-wrappedSQL-uid](<https://github.com/GaryAustin1/RLS-Performance/tree/main/tests/test2a-wrappedSQL-uid()>)                 | 179         | 9          | 94.97%        | <details className="cursor-pointer">Before:<br/>`auth.uid() = user_id` <br/><br/>After:<br/> `(select auth.uid()) = user_id`</details>                                    |
| [test2b-wrappedSQL-isadmin](<https://github.com/GaryAustin1/RLS-Performance/tree/main/tests/test2b-wrappedSQL-isadmin()>)         | 11,000      | 7          | 99.94%        | <details className="cursor-pointer">Before:<br/>`is_admin()` _table join_<br/><br/>After:<br/>`(select is_admin())` _table join_</details>                                |
| [test2c-wrappedSQL-two-functions](https://github.com/GaryAustin1/RLS-Performance/tree/main/tests/test2c-wrappedSQL-two-functions) | 11,000      | 10         | 99.91%        | <details className="cursor-pointer">Before:<br/>`is_admin() OR auth.uid() = user_id`<br/><br/>After:<br/>`(select is_admin()) OR (select auth.uid()) = user_id)`</details> |
| [test2d-wrappedSQL-sd-fun](https://github.com/GaryAustin1/RLS-Performance/tree/main/tests/test2d-wrappedSQL-sd-fun)               | 178,000     | 12         | 99.993%       | <details className="cursor-pointer">Before:<br/>`has_role() = role` <br/><br/>After:<br/>(select has_role()) = role</details>                                             |
| [test2e-wrappedSQL-sd-fun-array](https://github.com/GaryAustin1/RLS-Performance/tree/main/tests/test2e-wrappedSQL-sd-fun-array)   | 173000      | 16         | 99.991%       | <details className="cursor-pointer">Before:<br/>`team_id=any(user_teams())` <br/><br/>After:<br/>team_id=any(array(select user_teams()))</details>                        |

#### Add filters to every query

Policies are "implicit where clauses," so it's common to run `select` statements without any filters
* This is a bad pattern for performance
* Instead of doing this (JS client example):

```js
const { data } = supabase
  .from('table')
  .select()
```

You should always add a filter:

```js
const { data } = supabase
  .from('table')
  .select()
  .eq('user_id', userId)
```

Even though this duplicates the contents of the Policy, Postgres can use the filter to construct a better query plan.

##### Benchmarks

| Test                                                                                              | Before (ms) | After (ms) | % Improvement | Change                                                                                                                                 |
| ------------------------------------------------------------------------------------------------- | ----------- | ---------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| [test3-addfilter](https://github.com/GaryAustin1/RLS-Performance/tree/main/tests/test3-addfilter) | 171         | 9          | 94.74%        | <details className="cursor-pointer">Before:<br/>`auth.uid() = user_id`<br/><br/>After:<br/>add `.eq` or `where` on `user_id`</details> |

#### Use security definer functions

A "security definer" function runs using the same role that _created_ the function
* This means that if you create a role with a superuser (like `postgres`), then that function will have `bypassrls` privileges
* For example, if you had a policy like this:

```sql
create policy "rls_test_select" on test_table
to authenticated
using (
  exists (
    select 1 from roles_table
    where (select auth.uid()) = user_id and role = 'good_role'
  )
);
```

We can instead create a `security definer` function which can scan `roles_table` without any RLS penalties:

```sql
create function private.has_good_role()
returns boolean
language plpgsql
security definer -- will run as the creator
as $$
begin
  return exists (
    select 1 from roles_table
    where (select auth.uid()) = user_id and role = 'good_role'
  );
end;
$$;

-- Update our policy to use this function:
create policy "rls_test_select"
on test_table
to authenticated
using ( (select private.has_good_role()) );
```

> ⚠️ Security-definer functions should never be created in a schema in the "Exposed schemas" inside your [API settings](/dashboard/project/_/settings/api).

#### Minimize joins

You can often rewrite your Policies to avoid joins between the source and the target table
* Instead, try to organize your policy to fetch all the relevant data from the target table into an array or set, then you can use an `IN` or `ANY` operation in your filter.

For example, this is an example of a slow policy which joins the source `test_table` to the target `team_user`:

```sql
create policy "rls_test_select" on test_table
to authenticated
using (
  (select auth.uid()) in (
    select user_id
    from team_user
    where team_user.team_id = team_id -- joins to the source "test_table.team_id"
  )
);
```

We can rewrite this to avoid this join, and instead select the filter criteria into a set:

```sql
create policy "rls_test_select" on test_table
to authenticated
using (
  team_id in (
    select team_id
    from team_user
    where user_id = (select auth.uid()) -- no join
  )
);
```

In this case you can also consider [using a `security definer` function](#use-security-definer-functions) to bypass RLS on the join table.

> If the list exceeds 1000 items, a different approach may be needed or you may need to analyze the approach to ensure that the performance is acceptable.

##### Benchmarks

| Test                                                                                                | Before (ms) | After (ms) | % Improvement | Change                                                                                                                                            |
| --------------------------------------------------------------------------------------------------- | ----------- | ---------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| [test5-fixed-join](https://github.com/GaryAustin1/RLS-Performance/tree/main/tests/test5-fixed-join) | 9,000       | 20         | 99.78%        | <details className="cursor-pointer">Before:<br/>`auth.uid()` in table join on col<br/><br/>After:<br/>col in table join on `auth.uid()`</details> |

#### Specify roles in your policies

Always use the Role of inside your policies, specified by the `TO` operator
* For example, instead of this query:

```sql
create policy "rls_test_select" on rls_test
using ( auth.uid() = user_id );
```

Use:

```sql
create policy "rls_test_select" on rls_test
to authenticated
using ( (select auth.uid()) = user_id );
```

This prevents the policy `( (select auth.uid()) = user_id )` from running for any `anon` users, since the execution stops at the `to authenticated` step.

##### Benchmarks

| Test                                                                                          | Before (ms) | After (ms) | % Improvement | Change                                                                                                                           |
| --------------------------------------------------------------------------------------------- | ----------- | ---------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| [test6-To-role](https://github.com/GaryAustin1/RLS-Performance/tree/main/tests/test6-To-role) | 170         | < 0.1      | 99.78%        | <details className="cursor-pointer">Before:<br/>No `TO` policy<br/><br/>After:<br/>`TO authenticated` (anon accessing)</details> |

## Policies

* [Policies](https://www.postgresql.org/docs/current/sql-createpolicy.html) 
  * == Postgres's rule engine
    * are attached -- to -- a table
    * executed / EACH access to a table
  * == add a `WHERE` clause / EACH query
  * == TODO: SQL logic / attached -- to -- a Postgres table
    * You can attach as many policies as you want to each table.

Supabase provides some [helpers](#helper-functions) that simplify RLS 
if you're using Supabase Auth
* We'll use these helpers to illustrate some basic policies:

### SELECT policies

You can specify select policies with the `using` clause.

Say you have a table called `profiles` in the public schema and you want to enable read access to everyone.

```sql
-- 1. Create table
create table profiles (
  id uuid primary key,
  user_id uuid references auth.users,
  avatar_url text
);

-- 2. Enable RLS
alter table profiles enable row level security;

-- 3. Create Policy
create policy "Public profiles are visible to everyone."
on profiles for select
to anon         -- the Postgres Role (recommended)
using ( true ); -- the actual Policy
```

Alternatively, if you only wanted users to be able to see their own profiles:

```sql
create policy "User can see their own profile only."
on profiles
for select using ( (select auth.uid()) = user_id );
```

### INSERT policies

You can specify insert policies with the `with check` clause
* The `with check` expression ensures that any new row data adheres to the policy constraints.

Say you have a table called `profiles` in the public schema and you only want users to create a profile for themselves
* In that case, we want to check their User ID matches the value that they are trying to insert:

```sql
-- 1. Create table
create table profiles (
  id uuid primary key,
  user_id uuid references auth.users,
  avatar_url text
);

-- 2. Enable RLS
alter table profiles enable row level security;

-- 3. Create Policy
create policy "Users can create a profile."
on profiles for insert
to authenticated                          -- the Postgres Role (recommended)
with check ( (select auth.uid()) = user_id );      -- the actual Policy
```

### UPDATE policies

You can specify update policies by combining both the `using` and `with check` expressions.

The `using` clause represents the condition that must be true for the update to be allowed, and `with check` clause
ensures that the updates made adhere to the policy constraints.

Say you have a table called `profiles` in the public schema and you only want users to update their own profile.

You can create a policy where the `using` clause checks if the user owns the profile being updated
* And the `with check` clause ensures that, in the resultant row, users do not change the `user_id` to a value that 
is not equal to their User ID, maintaining that the modified profile still meets the ownership condition.

```sql
-- 1. Create table
create table profiles (
  id uuid primary key,
  user_id uuid references auth.users,
  avatar_url text
);

-- 2. Enable RLS
alter table profiles enable row level security;

-- 3. Create Policy
create policy "Users can update their own profile."
on profiles for update
to authenticated                    -- the Postgres Role (recommended)
using ( (select auth.uid()) = user_id )       -- checks if the existing row complies with the policy expression
with check ( (select auth.uid()) = user_id ); -- checks if the new row complies with the policy expression
```

If no `with check` expression is defined, then the `using` expression will be used both to determine 
which rows are visible (normal USING case) and which new rows will be allowed to be added (WITH CHECK case).

> ⚠️ To perform an `UPDATE` operation, a corresponding [SELECT policy](#select-policies) is required
> * Without a `SELECT` policy, the `UPDATE` operation will not work as expected.

### DELETE policies

You can specify delete policies with the `using` clause.

Say you have a table called `profiles` in the public schema and you only want users to be able to delete their own profile:

```sql
-- 1. Create table
create table profiles (
  id uuid primary key,
  user_id uuid references auth.users,
  avatar_url text
);

-- 2. Enable RLS
alter table profiles enable row level security;

-- 3. Create Policy
create policy "Users can delete a profile."
on profiles for delete
to authenticated                     -- the Postgres Role (recommended)
using ( (select auth.uid()) = user_id );      -- the actual Policy
```

### Views

Views bypass RLS by default because they are usually created with the `postgres` user
* This is a feature of Postgres, which automatically creates views with `security definer`.

In Postgres 15 and above, you can make a view obey the RLS policies of the underlying tables when invoked by `anon` and `authenticated` roles by setting `security_invoker = true`.

```sql
create view <VIEW_NAME>
with(security_invoker = true)
as select <QUERY>
```

In older versions of Postgres, protect your views by revoking access from the `anon` and `authenticated` roles, or by putting them in an unexposed schema.

## Authenticated & unauthenticated roles

* Supabase
  * maps EACH request -- to -- the roles
    * [`anon`](roles.md#anon)
    * [`authenticated`](roles.md#authenticated)

* if you want to use [Supabase roles](roles.md) | your Policies -> use the `TO` clause

  ```sql
  create policy "Profiles are viewable by everyone"
  on profiles for select
  to authenticated, anon
  using ( true );
  
  -- OR
  
  create policy "Public profiles are viewable only by authenticated users"
  on profiles for select
  to authenticated
  using ( true );
  ```

* [anonymous user is distinguished -- , via JWT's `is_anonymous` claim, by -- `authenticated` user](../../auth/auth-anonymous.md)

## Helper functions

* Supabase helper functions
  * allows
    * easier to write policies

### `auth.uid()`

* 's return
  * user ID / make the request

### `auth.jwt()`

* pros
  * versatile
* 's return
  * user's JWT / make the request
    * == ".json"
    * _Example of JWT's fields:_ 
      * `app_metadata`
        * == Postgres' `raw_app_meta_data` column
      * `user_metadata`
        * == Postgres' `raw_user_meta_data` column

* JWT
  * recommendation
    * ❌NOT use ALL information | RLS policies❌
      * Reason:🧠it can create security issues | your application
        * _Example:_ if you create a RLS policy / relies on the `user_metadata` claim -> this information can be modified by authenticated end users🧠

* `raw_user_meta_data` 
  * if authenticated user wants to update it -> use `supabase.auth.update()`
  * ❌NOT use cases❌
    * store authorization data
* `raw_app_meta_data`
  * can NOT be updated by the user
  * use cases
    * store authorization data

TODO:

* For example, if you store some team data inside `app_metadata`, 
you can use it to determine whether
a particular user belongs to a team
* For example, if this was an array of IDs:

```sql
create policy "User is in team"
on my_table
to authenticated
using ( team_id in (select auth.jwt() -> 'app_metadata' -> 'teams'));
```

<Admonition type="caution">

Keep in mind that a JWT is not always "fresh"
* In the example above, even if you remove a user from a team and update the `app_metadata` field, 
that will not be reflected using `auth.jwt()` until the user's JWT is refreshed.

Also, if you are using Cookies for Auth, then you must be mindful of the JWT size
* Some browsers are limited to 4096 bytes for each cookie, and so the total size of your JWT should be small enough 
to fit inside this limitation.

</Admonition>

### MFA

The `auth.jwt()` function can be used to check for [Multi-Factor Authentication](/docs/guides/auth/auth-mfa#enforce-rules-for-mfa-logins)
* For example, you could restrict a user from updating their profile unless they have at least 2 levels of authentication (Assurance Level 2):

```sql
create policy "Restrict updates."
on profiles
as restrictive
for update
to authenticated using (
  (select auth.jwt()->>'aal') = 'aal2'
);
```
