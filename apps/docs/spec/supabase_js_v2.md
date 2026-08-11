# auth-api

* if you want to access auth methods -> via `supabase.auth` namespace
* by default,
  * supabase client
    * sets `persistSession: true`
      * requirements
        * provide a CUSTOM storage implementation / follows [this interface](https://github.com/supabase/supabase-js/blob/master/packages/core/auth-js/src/lib/types.ts#L1053)
    * attempts to store the session | local storage
* if you use the supabase client | environment / does NOT support local storage -> log a warning
  * if you're NOT using auth | server-side -> ignore it
* email links & one-time passwords (OTPs) sent
  * default expiry: 24 hours
* [rate limits](../content/guides/deployment/going-into-prod.md#auth-rate-limits)
* [access token](../content/guides/auth/jwts.md)
* [access token](../content/guides/auth/jwt-fields.md)

* _Examples:_
  * Create auth client

    ```js
    import { createClient } from '@supabase/supabase-js'

    const supabase = createClient(supabase_url, publishable_key)
    ```
  * Create auth client | server-side

    ```js
    import { createClient } from '@supabase/supabase-js'
    
    const supabase = createClient(supabase_url, publishable_key, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUrl: false
      }
    })
    ```

# auth-mfa-api
    title: Overview
    notes: |
      This section contains methods commonly used for Multi-Factor Authentication (MFA) and are invoked behind the `supabase.auth.mfa` namespace.

      Currently, there is support for time-based one-time password (TOTP) and phone verification code as the 2nd factor. Recovery codes are not supported but users can enroll multiple factors, with an upper limit of 10.

      Having a 2nd factor for recovery frees the user of the burden of having to store their recovery codes somewhere. It also reduces the attack surface since multiple recovery codes are usually generated compared to just having 1 backup factor.

      Learn more about implementing MFA in your application [in the MFA guide](https://supabase.com/docs/guides/auth/auth-mfa#overview).

# passkey-api
    title: Auth Passkey
    notes: |
      This section contains methods for WebAuthn passkey registration, authentication, and management. Methods are invoked behind the `supabase.auth.passkey` namespace.

      Passkey support is an experimental feature. Enable it when creating the client:

      ```ts
      const supabase = createClient(supabaseUrl, publishableKey, {
        auth: {
          experimental: { passkey: true },
        },
      })
      ```

# admin-api
    title: Overview
    notes: |
      - Any method under the `supabase.auth.admin` namespace requires a `secret` key.
      - These methods are considered admin methods and should be called on a trusted server. Never expose your `secret` key in the browser.
    examples:
      - id: create-auth-admin-client
        name: Create server-side auth client
        isSpotlight: true
        code: |
          ```js
          import { createClient } from '@supabase/supabase-js'

          const supabase = createClient(supabase_url, secret_key, {
            auth: {
              autoRefreshToken: false,
              persistSession: false
            }
          })

          // Access auth admin api
          const adminAuthClient = supabase.auth.admin
          ```

# admin-passkey-api

* requirements
  * ⚠️a secret key⚠️

# admin-custom-providers-api
    title: Custom OIDC/OAuth Provider Admin API
    notes: |
      - These methods allow you to manage custom OIDC/OAuth providers programmatically.
      - Requires `secret` key.
      - Custom providers use the `custom:` prefix when signing in (e.g., `custom:my-oidc-provider`).

# using-filters
    title: Using Filters
    description: |
      Filters allow you to only return rows that match certain conditions.

      Filters can be used on `select()`, `update()`, `upsert()`, and `delete()` queries.

      If a Postgres function returns a table response, you can also apply filters.
    examples:
      - id: applying-filters
        name: Applying Filters
        description: |
          Filters must be applied after any of `select()`, `update()`, `upsert()`,
          `delete()`, and `rpc()` and before
          [modifiers](/docs/reference/javascript/using-modifiers).
        code: |
          ```ts
          const { data, error } = await supabase
            .from('instruments')
            .select('name, section_id')
            .eq('name', 'violin')    // Correct

          const { data, error } = await supabase
            .from('instruments')
            .eq('name', 'violin')    // Incorrect
            .select('name, section_id')
          ```
      - id: chaining-filters
        name: Chaining
        description: |
          Filters can be chained together to produce advanced queries. For example,
          to query cities with population between 1,000 and 10,000:

          ```ts
          const { data, error } = await supabase
            .from('cities')
            .select('name, country_id')
            .gte('population', 1000)
            .lt('population', 10000)
          ```
        code: |
          ```ts
          const { data, error } = await supabase
            .from('cities')
            .select('name, country_id')
            .gte('population', 1000)
            .lt('population', 10000)
          ```
      - id: conditional-chaining
        name: Conditional Chaining
        description: |
          Filters can be built up one step at a time and then executed. For example:

          ```ts
          const filterByName = null
          const filterPopLow = 1000
          const filterPopHigh = 10000

          let query = supabase
            .from('cities')
            .select('name, country_id')

          if (filterByName)  { query = query.eq('name', filterByName) }
          if (filterPopLow)  { query = query.gte('population', filterPopLow) }
          if (filterPopHigh) { query = query.lt('population', filterPopHigh) }

          const { data, error } = await query
          ```
        code: |
          ```ts
          const filterByName = null
          const filterPopLow = 1000
          const filterPopHigh = 10000

          let query = supabase
            .from('cities')
            .select('name, country_id')

          if (filterByName)  { query = query.eq('name', filterByName) }
          if (filterPopLow)  { query = query.gte('population', filterPopLow) }
          if (filterPopHigh) { query = query.lt('population', filterPopHigh) }

          const { data, error } = await query
          ```
      - id: filter-by-value-within-json-column
        name: Filter by values within a JSON column
        code: |
          ```ts
          const { data, error } = await supabase
            .from('users')
            .select()
            .eq('address->postcode', 90210)
          ```
        data:
          sql: |
            ```sql
            create table
              users (
                id int8 primary key,
                name text,
                address jsonb
              );

            insert into
              users (id, name, address)
            values
              (1, 'Michael', '{ "postcode": 90210 }'),
              (2, 'Jane', null);
            ```
        response: |
          ```json
          {
            "data": [
              {
                "id": 1,
                "name": "Michael",
                "address": {
                  "postcode": 90210
                }
              }
            ],
            "status": 200,
            "statusText": "OK"
          }
          ```
      - id: filter-referenced-tables
        name: Filter referenced tables
        description: |
          You can filter on referenced tables in your `select()` query using dot
          notation.
        code: |
          ```ts
          const { data, error } = await supabase
            .from('orchestral_sections')
            .select(`
              name,
              instruments!inner (
                name
              )
            `)
            .eq('instruments.name', 'flute')
          ```
        data:
          sql: |
            ```sql
            create table
              orchestral_sections (id int8 primary key, name text);
            create table
              instruments (
                id int8 primary key,
                section_id int8 not null references orchestral_sections,
                name text
              );

            insert into
              orchestral_sections (id, name)
            values
              (1, 'strings'),
              (2, 'woodwinds');
            insert into
              instruments (id, section_id, name)
            values
              (1, 2, 'flute'),
              (2, 1, 'violin');
            ```
          response: |
            ```json
            {
              "data": [
                {
                  "name": "woodwinds",
                  "characters": [
                    {
                      "name": "flute"
                    }
                  ]
                }
              ],
              "status": 200,
              "statusText": "OK"
            }
            ```

# using-modifiers
    title: Using Modifiers
    description: |
      Filters work on the row level—they allow you to return rows that
      only match certain conditions without changing the shape of the rows.
      Modifiers are everything that don't fit that definition—allowing you to
      change the format of the response (e.g., returning a CSV string).

      Modifiers must be specified after filters. Some modifiers only apply for
      queries that return rows (e.g., `select()` or `rpc()` on a function that
      returns a table response).

# oauth-server-api
    title: OAuth Server API
    notes: |
      The OAuth Server API allows you to build custom OAuth consent screens for your application.
      Only relevant when the OAuth 2.1 server is enabled in Supabase Auth.

# oauth-admin-api
    title: OAuth Admin API
    notes: |
      The OAuth Admin API allows you to manage OAuth clients programmatically.
      Only relevant when the OAuth 2.1 server is enabled in Supabase Auth.
      These functions should only be called on a server. Never expose your `secret` key in the browser.
