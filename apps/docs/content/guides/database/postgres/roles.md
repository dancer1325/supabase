---
id: 'postgres-roles'
title: 'Postgres Roles'
description: 'Managing access to your Postgres database and configuring permissions.'
subtitle: 'Managing access to your Postgres database and configuring permissions.'
---

* roles
  * == Postgres' concept /
    * allows
      * manages database access permissions 
  * use cases
    * configure system access -- to -- your database
  * ❌NOT use cases ❌
    * | your OWN application

* [RLS](row-level-security.md)
  * uses
    * configure your application access 

* [RBAC](../../api/custom-claims-and-role-based-access-control-rbac)
  * can be implemented | RLS

## Users vs roles

* | Postgres,
  * ⚠️roles vs users OR groups of users⚠️
    * users
      * 👀== roles + login privileges👀 
    * groups OR role groups
      * == roles / NOT have login privileges
      * uses
        * manage permissions -- for -- >1 user

## Creating roles

```sql
create role "role_name";
```

## Creating users

* if you want to use password-logins / specific role -> use `WITH LOGIN PASSWORD`

    ```sql
    create role "role_name" with login password 'extremely_secure_password';
    ```

## Passwords

* recommendation
  * strong secure password / EACH role
  * | create a secure password
    * generate it -- through -- a password manager 
    * password's length \>= 12 characters
    * NOT use ANY COMMON dictionary words
    * use 
      * upper and lower case characters
      * numbers
      * [special symbols](#special-symbols)

### Special symbols

TODO: 
If you use special symbols in your Postgres password, you must remember to [percent-encode](https://en.wikipedia.org/wiki/Percent-encoding)
your password later if using the Postgres connection string, for example,
`postgresql://postgres.projectref:p%3Dword@aws-0-us-east-1.pooler.supabase.com:6543/postgres`

### Changing your project password

When you created your project you were also asked to enter a password
* This is the password for the `postgres` role in your database
* You can update this from the Dashboard under the [Database Settings](/dashboard/project/_/database/settings) page
* You should _never_ give this to third-party service unless you absolutely trust them
* Instead, we recommend that you create a new user for every service that you want to give access too
* This will also help you with debugging - you can see every query that each role is executing 
in your database within `pg_stat_statements`.

Changing the password does not result in any downtime
* All connected services, such as PostgREST, PgBouncer, and other Supabase managed services,
are automatically updated to use the latest password to ensure availability
* However, if you have any external services connecting to the Supabase database using
hardcoded username/password credentials, a manual update will be required.

## Granting permissions

Roles can be granted various permissions on database objects using the `GRANT` command
* Permissions include `SELECT`, `INSERT`, `UPDATE`, and `DELETE`
* You can configure access to almost any object inside your database - including tables, views, functions, and triggers.

## Revoking permissions

Permissions can be revoked using the `REVOKE` command:

```sql
REVOKE permission_type ON object_name FROM role_name;
```

## Role hierarchy

Roles can be organized in a hierarchy, where one role can inherit permissions from another
* This simplifies permission management, as you can define permissions at a higher level and 
have them automatically apply to all child roles.

### Role inheritance

To create a role hierarchy, you first need to create the parent and child roles
* The child role will inherit permissions from its parent
* Child roles can be added using the INHERIT option when creating the role:

```sql
create role "child_role_name" inherit "parent_role_name";
```

### Preventing inheritance

In some cases, you might want to prevent a role from having a child relationship (typically superuser roles)
* You can prevent inheritance relations using `NOINHERIT`:

```sql
alter role "child_role_name" noinherit;
```

## Supabase roles

* == Postgres' [predefined roles](https://www.postgresql.org/docs/current/predefined-roles.html) / 👀extended👀
  * are configured | your database
  * predefined
    * == | start a NEW project, ALREADY exist

### `postgres`

* == default Postgres role /
  * has
    * admin privileges

### `anon`

* uses
  * unauthenticated
    * == unauthenticated users
  * public access
    * == public users
* use cases
  * by PostgREST, for a user / NOT logged in
* ❌!= Supabase Auth's [anonymous user](../../auth/auth-anonymous)❌

### `authenticator`

* uses
  * validate a JWT
* use case
  * by PostgREST
* restrictions
  * ⚠️very limited access⚠️

### `authenticated`

* uses
  * "authenticated access"
  * access -- , via Data APIs, to -- your project
* use cases
  * by PostgREST, for a user / logged in

### `service_role`

TODO: 
For elevated access
* This role is used by the API (PostgREST) to bypass Row Level Security.

### `supabase_auth_admin`

Used by the Auth middleware to connect to the database and run migration
* Access is scoped to the `auth` schema.

### `supabase_storage_admin`

Used by the Auth middleware to connect to the database and run migration
* Access is scoped to the `storage` schema.

### `supabase_etl_admin`

`supabase_etl_admin` is used by Supabase Pipelines for [Database replication](/docs/guides/database/replication).

This role:

- Replicates database changes to destination systems
- Has read-all access
- Has replication privileges for change data capture, bypasses Row Level Security
- Can create event triggers
- Can write to the `etl` schema

### `dashboard_user`

For running commands via the Supabase UI.

### `supabase_admin`

* == Supabase's internal role
* uses
  * administrative tasks    
    * _Example:_ running upgrades & automations

## Resources

- Official Postgres docs: [Database Roles](https://www.postgresql.org/docs/current/database-roles.html)
- Official Postgres docs: [Role Membership](https://www.postgresql.org/docs/current/role-membership.html)
- Official Postgres docs: [Function Permissions](https://www.postgresql.org/docs/current/perm-functions.html)
