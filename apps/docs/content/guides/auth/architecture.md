---
title: 'Auth architecture'
subtitle: 'The architecture behind Supabase Auth.'
---

* Supabase Auth's main layers
  1. [client layer](#client-layer)
  2. Kong API gateway
  3. [Auth service](#auth-service)
  4. [Postgres database](#postgres)

## Client layer

* client layer
  * can run | 
    * your app 
    * your
      * FE browser code
      * BE server code
      * native application
  * 's functions
    * uses
      * sign in
      * manage users
  * ways to use it
    * -- through -- Supabase client SDKs
    * -- through -- HTTP requests

* Supabase Client SDKs
  * handle
    * configuration &z authentication of HTTP calls -- to the -- Supabase Auth backend
    * | your app's storage medium, about Auth Tokens
      * persistence
      * refresh
      * removal 
    * integration -- with -- OTHER Supabase products
  * AVAILABLE ones
    - [JavaScript](/docs/reference/javascript/introduction)
    - [Flutter](/docs/reference/dart/introduction)
    - [Swift](/docs/reference/swift/introduction)
    - [Python](/docs/reference/python/introduction)
    - [C#](/docs/reference/csharp/introduction)
    - [Kotlin](/docs/reference/kotlin/introduction)
  * recommendation
    * use it -- rather than -- client layer

## [Auth service](https://github.com/supabase/auth)

* == Auth API server /
  * maintained -- by -- Supabase
  * == fork of the GoTrue project
    * created -- by -- Netlify
  * responsible for
    * Validating, issuing, and refreshing JWTs
    * being the intermediary BETWEEN your app -- & -- Auth information | the database
    * Communicating -- , for Social Login & SSO, with -- EXTERNAL providers 
  * how is it used by Supabase?
    * | deploy a NEW Supabase project, Supabase
      * deploy an Auth service instance + your database
      * inject your database -- with -- the required Auth schema

## Postgres

* ⚠️shared BETWEEN ALL Supabase products⚠️
* `auth` schema | your Postgres database
  * | auto-generated API,
    * ❌NOT exposed❌ 
  * uses
    * by Supabase, to store 
      * user tables
      * OTHER information

* if you want to connect Auth information -- to -- your OWN objects -> use
  * [database triggers](../database/postgres/triggers) 
  * [foreign keys](https://www.postgresql.org/docs/current/tutorial-fk.html)
  * BOTH

* recommendations
  * protect the views / you create for Auth data,
    * -- by --
      * [enabling RLS](../database/postgres/row-level-security) OR 
      * [revoking grants](https://www.postgresql.org/docs/current/sql-revoke.html)

* views
  * | Postgres v15+, 
    * if they are created with `security_invoker` -> inherit the underlying tables' RLS policies
  * | Postgres v15-,
    * OR views / created WITHOUT `security_invoker`,
      * inherit the owner's permissions
      * -> can bypass RLS policies
