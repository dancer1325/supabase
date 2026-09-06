---
id: 'functions-secrets'
title: 'Environment Variables'
description: 'Managing secrets and environment variables.'
subtitle: 'Manage sensitive data securely across environments.'
---

## Default secrets

* secrets / Edge Functions have access 
  * by default
    - `SUPABASE_URL`
      - == Supabase project's API gateway 
    - `SUPABASE_DB_URL`
      - your Postgres database's URL
    - `SUPABASE_PUBLISHABLE_KEYS`
      - your Supabase API's `publishable` keys 
      - if you have enabled RLS -> safe to use | a browser
    * `SUPABASE_SECRET_KEYS`
      * your Supabase API's `secret` keys /
        * bypass RLS 
      * use cases
        * | Edge Functions
      * ❌NOT use cases❌
        * | browser
    - `SUPABASE_JWKS`
      - uses
        - verify user JWTs
      - == https://<project-ref>.supabase.co/auth/v1/.well-known/jwks.json

* legacy keys / Edge Functions have access
  - `SUPABASE_ANON_KEY`
    - The `anon` key for your Supabase API
    - This is safe to use in a browser when you have Row Level Security enabled
  * `SUPABASE_SERVICE_ROLE_KEY`
    * == your Supabase API's `service_role` key /
      * bypass RLS
    * ❌NOT use cases❌
      * | browser

* environment variables / Edge Functions have access
  * | hosted environment,
    - `SB_REGION`
      - == region function / was invoked
    - `SB_EXECUTION_ID`
      - == [function instance's UUID](../functions/architecture.md#4-execution-mechanics-fast-and-isolated)
    - `DENO_DEPLOYMENT_ID`
      - == function code's version
        - (`{project_ref}_{function_id}_{version}`)

## how to access environment variables?

* steps to access environment variables
  * Deno's built-in handler
  * passing the name of the environment variable

    ```js
    Deno.env.get('NAME_OF_SECRET')
    ```

### Local secrets

* ways to load environment variables
  1. -- through -- "supabase/functions/.env" /
     * AUTOMATICALLY loaded | `supabase start`
  2. -- through -- `supabase functions serve --env-file <PATH_FROM_ROOT_PATH_TO_ENV_FILE>`
     * allows you to 
       * use custom file names
         * _Example:_ ".env.local"
     * use cases
       * DIFFERENT environments

* ".env"
  * add | ".gitignore"

* steps to invoke LOCALLY our function
  * load the environment variables
  * | Edge Functions,
    * you can access -- , through Deno’s handler, to -- the environment variables

      ```tsx
      const secretKey = Deno.env.get('STRIPE_SECRET_KEY')
      ```
  * invoke our function locally
    * if you're using 
      * the default ".env" (== | "supabase/functions/.env") -> `supabase functions serve <EDGE_FUNCTION_NAME>`
      * a custom ".env" -> `supabase functions serve <EDGE_FUNCTION_NAME> --env-file <PATH_FROM_ROOT_PATH_TO_ENV_FILE>`

### Production secrets

* ways 
  * -- via -- Supabase Dashboard
    * steps
      * Supabase Dashboard > project > choose the project > functions > secrets > add 

        ![Edge Functions Secrets Management (dark)](../../../public/img/edge-functions-secrets.jpg)

  * -- via -- Supabase CLI
    * steps
      * `touch .env.production`
      * | ".gitignore"

        ```bash
        .env.production
        ```

      * `vim .env.production`

        ```bash
        # .env
        STRIPE_SECRET_KEY=sk_live_...
        ```
      * `supabase secrets set --env-file .env.production`
        * == push ALL ".env.production"'s secrets | your remote project / 
          * == environment is visible | dashboard
          * ⚠️IMMEDIATELY AVAILABLE | your functions⚠️
            * == ❌you do NOT need to re-deploy❌
        * if you want to set secrets INDIVIDUALLY -> `supabase secrets set <SECRET_KEY>=<SECRET_VALUE>`
      * `supabase secrets list`
        * check ALL secrets / set REMOTELY
