---
id: 'api-keys'
title: 'Understanding API keys'
description: "First-layer protection for your project's data"
---

* Supabase Auth
  * builds | API keys 
    * API keys 
      * == FIRST layer of authentication -- for -- data access 
      * enable you: fine-grained control -- about the -- application components / can access your project 

* ways to get
  * | Supabase Dashboard > Choose a project > Connect dialog
    * url: https://supabase.com/dashboard/project/<PROJECT_KEY>?showConnect=true
  * | Supabase Dashboard > Choose a project > Settings > API Keys
    * url: https://supabase.com/dashboard/project/<PROJECT_KEY>/settings/api-keys/

| Responsibility           | Question                           | Answer                                             |
|--------------------------| ---------------------------------- | -------------------------------------------------- |
| API keys                 | **What** is accessing the project? | Web page, mobile app, server, Edge Function...     |
| [Supabase Auth](../auth) | **Who** is accessing the project?  | Monica, Jian Yang, Gavin, Dinesh, Laurie, Fiona... |

## Overview

* API key
  * authenticates an application component / give it access -- to -- Supabase services
    * _Example of application component:_ web page, a mobile app, or a server
  * types | Supabase
    * ⚠️[deprecated API key types](../../_partials/api_keys_deprecation.md)⚠️
    * | SAME time, you can use NEW & legacy keys
      * if you want, [you can disable using legacy keys](migrating-to-new-api-keys.md)

| Type             | Format                 | Privileges | Availability   | Use                                             |
|------------------|------------------------| ---------- |----------------|-------------------------------------------------|
| Publishable key  | `sb_publishable_...`   | Low        | Platform       | client-side operations                          |
| Secret keys      | `sb_secret_...`        | Elevated   | Platform       | server-side operations                          |
| `anon`           | JWT (long lived)       | Low        | Platform, CLI  | == ⚠️Legacy version -- of -- publishable keys⚠️ |
| `service_role`   | JWT (long lived)       | Elevated   | Platform, CLI  | == ⚠️Legacy version -- of -- secret keys⚠️      |

## Publishable keys

* Publishable keys 
  * allows
    * identify your application's public components 

* your application's public components
  * run | environments /
    * ⚠️IMPOSSIBLE to secure any secrets⚠️
      * Reason:🧠anyone can retrieve -- , from the source code OR build artifacts, , -- the key🧠 
      * _Examples:_
        * web pages -- key bundled | source code --
        * mobile / desktop apps -- key bundled | compiled packages / executables --
        * CLI / scripts / tools / pre-built executables
        * publicly available APIs / return the key WITHOUT prior authorization

### interaction -- with -- Supabase Auth

TODO: 
Using a publishable key does not mean that your user is anonymous
* You can authenticate your application with the publishable key, while your user is authenticated 
(via Supabase Auth) with their personal JWT:

| Key             | User logged in -- via -- Supabase Auth | Postgres role / used for RLS, etc. |
| --------------- |----------------------------------------|------------------------------------|
| Publishable key | No                                     | `anon`                             |
| Publishable key | Yes                                    | `authenticated`                    |

### Security considerations

Publishable keys are not intended to protect from the following, since key retrieval is always possible
from a public component:

- Static or dynamic code analysis and reverse engineering attempts.
- Use of the Network inspector in the browser.
- Cross-site request forgery, cross-site scripting, phishing attacks.
- Man-in-the-middle attacks.

When using a publishable key, access to your project's data is guarded by Postgres via the built-in `anon`
and `authenticated` roles
* For full protection make sure:

- You have enabled Row Level Security on all tables.
- You regularly review your Row Level Security policies for permissions granted to the `anon` and
`authenticated` roles.
- You do not modify the role's attributes without understanding the changes you are making.

Your project's [Security Advisor](/dashboard/project/_/advisors/security) constantly checks for common security problems 
with the built-in Postgres roles
* Make sure you carefully review each finding before dismissing it.

## Secret keys

* TODO: 
\| your app's backend components: servers, already secured APIs (admin panels), Edge Functions, microservices, etc <br/> 
provide: FULL access -- to -- your project's data <br/> &nbsp;&nbsp; Reason:🧠 bypass Row Level Security🧠

### What secret keys allow access to

Unlike publishable keys, secret keys allow elevated access to your project's data
* It is meant to be used only in secure, developer-controlled components of your application, such as:

- Servers that implement prior authorization themselves, such as Edge Functions, microservices, traditional or specialized web servers.
- Periodic jobs, queue processors, topic subscribers.
- Admin and back-office tools, with prior authorization checks only.
- Data processing pipelines, such as for analytics, reports, backups, or database synchronization.

<Admonition type="caution">

Never expose your secret keys publicly
* Your data is at risk
* **Do not:**

- Add it to web pages, public documents, source code, bundle in executables or packages for mobile, desktop or CLI apps.
- Send over chat applications, email or SMS to your peers.
- Never use in a browser, even on `localhost`.
- Do not pass in URLs or query params, as these are often logged.
- Be careful passing them in request headers without prior log sanitization.
- Take extra care logging even potentially **invalid API keys**
* Typos might reveal the real key in the future.
- Reveal, copy, use or manipulate on hardware devices without full disk encryption and which you do not directly own or control (such as public computers, friend's laptop, etc.)

Ensure you handle them with care and using [secure coding practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/stable-en/).

</Admonition>

Secret keys authorize access to your project's data via the built-in `service_role` Postgres role
* By design, this role has full access to your project's data
* It also uses the [`BYPASSRLS` attribute](https://www.postgresql.org/docs/current/ddl-rowsecurity.html#:~:text=BYPASSRLS), skipping any and all Row Level Security policies you attach.

* secret key 
  * recommendation
    * use it -- rather than -- `service_role` key
      * Reason:🧠prevent misuse
        * can NOT be used | browser 
          * matches vs `User-Agent` header 
          * == reply with HTTP 401 Unauthorized
        * if you are NOT using them ->  NOT need to have any secret keys🧠 

* `service_role` key
  * == JWT-based

#### Best practices for handling secret keys

Below are some starting guidelines on how to securely work with secret keys:

- Always work with secret keys on computers you fully own or control.
- Use secure & encrypted send tools to share API keys with others (often provided by good password managers), but prefer the [**Settings > API Keys**](/dashboard/project/_/settings/api-keys/) section of the Dashboard instead.
- Prefer encrypting them when stored in files or environment variables.
- Do not add in source control, especially for CI scripts and tools
* Prefer using the tool's native secrets capability instead.
- Prefer using a separate secret key for each separate backend component of your application, so that if one is found to be vulnerable or to have leaked the key you will only need to change it and not all.
- Even though a secret key will always return HTTP 401 Unauthorized error when used in a browser, it does not mean that attackers will not use it with other tools
* Delete immediately!
- If you must include them in logs, log the first few random characters (but never more than 6).
- If you wish to log or store which valid API key was used, store it as a SHA256 hash.

#### What to do if a secret key or `service_role` has been leaked or compromised?

Don't rush if this has happened, or you are suspecting it has
* Make sure you have fully considered the situation and have remediated the root cause of the suspicion or vulnerability **first**
* Consider using the [OWASP Risk Rating Methodology](https://owasp.org/www-community/OWASP_Risk_Rating_Methodology) as an easy way to identify the severity of the incident and to plan your next steps.

To rotate a secret key (`sb_secret_...`), use the [**Settings > API Keys**](/dashboard/project/_/settings/api-keys/) section of the Dashboard to create a new secret API key, then replace it with the compromised key
* Once all components are using the new key, delete the compromised one.

**Deleting a secret key is irreversible and once done it will be gone forever.**

If you are still using the JWT-based `service_role` key, replace the `service_role` key with a new secret key instead
* Follow the guide from above as if you are rotating an existing secret key.

## Known limitations & compatibility differences

As the publishable and secret keys are no longer JWT-based, there are some known limitations and compatibility differences that you may need to plan for:

- You cannot send a publishable or secret key in the `Authorization: Bearer ...` header, except if the value exactly equals the `apikey` header
* In this case, your request will be forwarded down to your project's database, but will be rejected as the value is not a JWT.
- Edge Functions **only support JWT verification** via the `anon` and `service_role` JWT-based API keys
* You will need to use the `--no-verify-jwt` option when using publishable and secret keys
* The Supabase platform does not verify the `apikey` header when using Edge Functions in this way
* Implement your own `apikey`-header authorization logic inside the Edge Function code itself.
- Public Realtime connections are limited to 24 hours in duration, unless the connection is upgraded and further maintained with user-level authentication via Supabase Auth or a supported Third-Party Auth provider.
