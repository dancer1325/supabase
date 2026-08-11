---
title: 'Postgres SSL Enforcement'
description: 'Enforce SSL usage for all Postgres connections'
---

* Postgres SSL Enforcement
  * == ❌if your clients do NOT use SSL -> they can NOT connect❌
  * ⚠️default behavior | ALL HTTP APIs / offered -- by -- Supabase⚠️
  * 👀it can be disabled👀
    * | connect -- to --
      * Postgres
      * Supavisor (shared Connection Pooler) 
      * PgBouncer (dedicated Connection Pooler)
    * -> maximize client compatibility
  * ⚠️change this enforcement -> trigger a FAST database reboot⚠️
    * _Example:_ 
      * | small projects, it takes few seconds
      * | long projects, it takes MANY seconds
  * ways to manage
    * [-- via -- Supase dashboard](#---via----supase-dashboard)
    * [-- via -- Management API](#---via----management-api)
    * [-- via -- CLI](#---via----cli)

## -- via -- Supase dashboard

* steps
  * Supabase Dashboard > Choose your project > Database > Settings

## -- via -- Management API

* [Management API](../../../docs/ref/api/introduction.md)

```bash
# Get your access token from https://supabase.com/dashboard/account/tokens
export SUPABASE_ACCESS_TOKEN="your-access-token"
export PROJECT_REF="your-project-ref"

# Get current SSL enforcement status
curl -X GET "https://api.supabase.com/v1/projects/$PROJECT_REF/ssl-enforcement" \
  -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN"

# Enable SSL enforcement
curl -X PUT "https://api.supabase.com/v1/projects/$PROJECT_REF/ssl-enforcement" \
  -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "requestedConfig": {
      "database": true
    }
  }'

# Disable SSL enforcement
curl -X PUT "https://api.supabase.com/v1/projects/$PROJECT_REF/ssl-enforcement" \
  -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "requestedConfig": {
      "database": false
    }
  }'
```

## -- via -- CLI

* requirements
  * [project's owner OR admin permissions](access-control.md#manage-organization-members)
* steps
  * [install Supabase CLI 1.37.0+](../cli)
  * [log in | your Supabase account -- through -- CLI](../local-development/database-migrations.md#log-in--supabase-cli)

### Check SSL enforcement status

```bash
supabase ssl-enforcement get --project-ref {ref} --experimental
```

### Update enforcement

* enable your project's SSL enforcement status 

  ```bash
  supabase ssl-enforcement update --project-ref {ref} --enable-db-ssl-enforcement --experimental
  ```

* disable your project's SSL enforcement status

  ```bash
  supabase ssl-enforcement update --project-ref {ref} --disable-db-ssl-enforcement --experimental
  ```

### Postgres SSL modes

TODO: 
Postgres supports [multiple SSL modes](https://www.postgresql.org/docs/current/libpq-ssl.html#LIBPQ-SSL-PROTECTION) on the client side
* These modes provide different levels of protection
* Depending on your needs, it is important to verify that the SSL mode in use is performing the required level of enforcement and
verification of SSL connections.

| SSL Mode      | Encryption | Verifies CA | Verifies Hostname | Description                                                                                                                            |
| ------------- | ---------- | ----------- | ----------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `disable`     | No         | No          | No                | SSL is not used. All data is transmitted in plaintext.                                                                                 |
| `allow`       | Optional   | No          | No                | Tries a non-SSL connection first; falls back to SSL if the server requires it.                                                         |
| `prefer`      | Optional   | No          | No                | Tries an SSL connection first; falls back to non-SSL if the server doesn't support it. This is the default.                            |
| `require`     | Yes        | No          | No                | Always uses SSL, but does not verify the server certificate or hostname.                                                               |
| `verify-ca`   | Yes        | Yes         | No                | Uses SSL and verifies that the server certificate is signed by a trusted CA.                                                           |
| `verify-full` | Yes        | Yes         | Yes               | Uses SSL, verifies the CA certificate, and confirms the hostname matches the certificate. Recommended when SSL enforcement is enabled. |

The strongest mode offered by Postgres is `verify-full` and this is the mode you most likely want to use when SSL enforcement is enabled
* To use `verify-full` you will need to download the Supabase CA certificate for your database
* The certificate is available through the dashboard under the SSL Configuration section in the [Database Settings page](/dashboard/project/_/database/settings).

Once the CA certificate has been downloaded, add it to the certificate authority list used by Postgres.

```bash
cat {location of downloaded prod-ca-2021.crt} >> ~/.postgres/root.crt
```

With the CA certificate added to the trusted certificate authorities list, use `psql` or your client library to connect to Supabase:

```bash
psql "postgresql://aws-0-eu-central-1.pooler.supabase.com:6543/postgres?sslmode=verify-full" -U postgres.<user>
```
