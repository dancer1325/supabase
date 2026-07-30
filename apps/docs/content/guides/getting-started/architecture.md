---
title: 'Architecture'
description: 'Supabase design and architecture'
tocVideo: 'T-qAtAKjqwc'
---

## Architecture

* Supabase's architecture 
  * == >=1 tools

  ![Architecture](../../../public/img/supabase-architecture.svg)

### [Postgres (database)](https://www.postgresql.org)

* Postgres
  * == core of Supabase
  * ❌NOT abstracted❌
    * == you ca use it -- with -- FULL privileges

### [Studio (dashboard)](../../../../studio)

* == Dashboard /
  * allows
    * manage 
      * your database
      * your services
  * is
    * open source 

### [GoTrue (Auth)](https://github.com/supabase/gotrue)

* == JWT-based API /
  * allows
    * manage users
    * issue access tokens
  * integrates -- with -- 
    * Postgres's Row Level Security
    * API servers
  * uses
    * sign-ups | your applications
    * logins | your applications
    * session management | your applications

### [PostgREST (API)](https://github.com/PostgREST/postgrest)

* == standalone web server /
  * turns your Postgres database directly -- into a -- RESTful API
  * \+ [`pg_graphql` extension](https://github.com/supabase/pg_graphql)
    * == PostgreSQL extension /
      * provide
        * a GraphQL API

### [Realtime (API & multiplayer)](https://github.com/supabase/realtime)

* == Elixir server /
  * is
    * scalable
  * allows, -- , via WebSocket engine, --
    * manage 
      * user Presence
      * broadcasting messages
      * streaming database changes
  * how does it work?
    * steps
      * polls Postgres' built-in replication functionality -- for -- database changes
      * converts changes -- to -- JSON 
      * broadcasts the JSON -- , over websockets, to -- authorized clients

### [Storage API (large file storage)](https://github.com/supabase/storage-api)

An S3-compatible object storage service that stores metadata in Postgres.

* == RESTful API
  * allows
    * manage -- , via Postgres handling permissions, -- files | S3, with 

### [Deno (Edge Functions)](https://github.com/denoland/deno)

* == modern runtime -- for -- JS & TS

### [`postgres-meta` (database management)](https://github.com/supabase/postgres-meta)

* == RESTful API /
  * allows
    * manage your Postgres
      * _Examples:_
        * fetch tables
        * add roles
        * run queries

### [Supavisor](https://github.com/supabase/supavisor)

* == Postgres connection pooler /
  * cloud-native
  * multi-tenant 

### [Kong (API gateway)](https://github.com/kong/kong)

* == cloud-native API gateway /
  * built | NGINX

## Product principles

* 's goal
  * scalable
  * wide tooling /
    * usable -- by -- WIDE audience [indie-developers, small teams]

### EACH Supabase's service works in isolation

### ALL Supabase's service are integrated

Supabase is composable
* -> EACH Supabase's tool expose 
  * API
  * Webhooks

### EACH Supabase's service is extensible

* ❌!= add NEW Supabase's service❌

### Everything is portable

* == cloud offering is compatible -- with -- self-hosted product
  * -- thanks to -- use EXISTING standards
    * _Examples:_
      * `pg_dump`
      * .csv

### long-term approach

* ❌!= short-term ❌

### audience: developers

* -> Supabase changes | time

### Support existing tools

* [here](../../../../www/_blog/2022-08-12-supabase-series-b.md#giving-back)
