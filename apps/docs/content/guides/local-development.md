---
title: Local Development & CLI
subtitle: Learn how to develop locally and use the Supabase CLI
---

* goal
  * develop your applications -- via -- the locally running Supabase stack

* ⚠️requirements⚠️
  * install the [Supabase CLI](local-development/cli/getting-started)
  * container runtime / Docker APIs-compatible
    * Reason:🧠| run supabase project, bootstrap Supabase's components -- as -- containers🧠
    * _Example:_
      * [Docker Desktop](https://docs.docker.com/desktop/)
        * recommended on
      * [Rancher Desktop](https://rancherdesktop.io/) (macOS, Windows, Linux)
      * [Podman](https://podman.io/) (macOS, Windows, Linux)
      * [OrbStack](https://orbstack.dev/) (macOS)
      * [colima](https://github.com/abiosoft/colima) (macOS)

## how to start?

* steps
  * | your repo, 
    * initialize the local Supabase project

      ```bash
      npx supabase init
      ---
      yarn supabase init
      ---
      pnpm supabase init
      ---
      supabase init
      ```
      * | FIRST run,
        * it takes times
          * Reason:🧠CLI needs to download the Docker images | your local machine🧠
      * == create "supabase/"
        * it can be committed
    * start the local Supabase stack

        ```bash
        npx supabase start
        ---
        yarn supabase start
        ---
        pnpm supabase start
        ---
        supabase start
        ```
      * 's output
        * your local Supabase credentials
        * provided tools
          * Supabase Studio

            ![Local Studio](../../public/img/guides/cli/local-studio.png)
          * API Gateway
            * if you try to access these services WITHOUT the client libraries -> pass the client keys -- as an -- [`Authorization` header](auth/jwts)
          * Postgres
            * if you want to access -> -- through -- ANY Postgres client
              * _Examples:_  [`psql`](https://www.postgresql.org/docs/current/app-psql.html), [pgAdmin](https://www.pgadmin.org/)
            * if you want to access the database -- through -- edge function | your local Supabase setup -> replace `localhost` -- with -- `host.docker.internal`
          * Supabase Analytics Server
            * accesses the docker logging driver -- through -- 
              * volume / mounted | "/var/run/docker.sock" domain socket | Linux and macOS, OR
              * expose `tcp://localhost:2375` daemon socket | Windows
            * logs are stored | local database | `_analytics` schema
            * if you want advanced logs analysis -- via -- Logs Explorer -> use the [BigQuery backend](self-hosting/docker.md)

            ```
            Started supabase local development setup.
          
            ╭──────────────────────────────────────╮
            │ 🔧 Development Tools                 │
            ├─────────┬────────────────────────────┤
            │ Studio  │ http://127.0.0.1:54323     │
            │ Mailpit │ http://127.0.0.1:54324     │
            │ MCP     │ http://127.0.0.1:54321/mcp │
            ╰─────────┴────────────────────────────╯
          
            ╭──────────────────────────────────────────────────────╮
            │ 🌐 APIs                                              │
            ├────────────────┬─────────────────────────────────────┤
            │ Project URL    │ http://127.0.0.1:54321              │
            │ REST           │ http://127.0.0.1:54321/rest/v1      │
            │ GraphQL        │ http://127.0.0.1:54321/graphql/v1   │
            │ Edge Functions │ http://127.0.0.1:54321/functions/v1 │
            ╰────────────────┴─────────────────────────────────────╯
          
            ╭───────────────────────────────────────────────────────────────╮
            │ ⛁ Database                                                    │
            ├─────┬─────────────────────────────────────────────────────────┤
            │ URL │ postgresql://postgres:postgres@127.0.0.1:54322/postgres │
            ╰─────┴─────────────────────────────────────────────────────────╯
          
            ╭──────────────────────────────────────────────────────────────╮
            │ 🔑 Authentication Keys                                       │
            ├─────────────┬────────────────────────────────────────────────┤
            │ Publishable │ sb_publishable_...                             │
            │ Secret      │ sb_secret_...                                  │
            ╰─────────────┴────────────────────────────────────────────────╯
            ```

      * 👀if your local development machine is connected -- to an -- untrusted public network -> create a separate Docker network & bind to 127.0.0.1👀
        * Reason:🧠 restrict network access -- to -- ONLY your localhost machine🧠

        ```sh
        docker network create -o 'com.docker.network.bridge.host_binding_ipv4=127.0.0.1' local-network
        npx supabase start --network-id local-network
        ```
      * recommendations
        * ❌NEVER expose your local development stack PUBLICLY❌
  * | your browser,
    * http://localhost:54323
      * your local Supabase instance

## how to stop (WITHOUT resetting your local database) ?

```bash
supabase stop
```

## Local development

* Supabase -- via -- local development
  * allows you to
    * work on your projects | self-contained environment | your local machine
  *  advantages
    1. Faster development
       * == make changes & see results INSTANTLY WITHOUT waiting for remote deployments
    2. Offline work
       * == develop WITHOUT internet connection
    3. Cost-effective
       * == free
    4. Enhanced privacy
       * Reason:🧠sensitive data lives | your local machine🧠
    5. Safe testing
       * Reason:🧠you experiment with DIFFERENT configurations + features / WITHOUT affecting your production environment🧠

### vs Supabase Platform

* update your project settings
  * | Supabase Dashboard,
    * ❌NOT POSSIBLE ❌
  * | local developlment
    * -- via -- "config.toml"
* CONSTANTLY NEW features & bug fixes
  * | Supabase Platform