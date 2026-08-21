# prerequirements
* download Docker Desktop
* `npx supabase init` OR `supabase init`
* `npx supabase start` OR `supabase start`

# What is a session?
TODO:
## session
TODO:
### | user signs in, it's created
TODO:
### ⚠️by default,
TODO:
#### it lasts indefinitely
TODO:
#### can be unlimited number / EACH user⚠️
TODO:
### == JWT (access token) + refresh token
TODO:
#### JWT
TODO:
##### short life [5 minutes, 1 hour]
TODO:
#### refresh token
TODO:
##### NEVER expire
TODO:
##### refresh the session
TODO:
###### == exchange an old refresh token -- by -- a NEW access & refresh token
TODO:
####### old refresh token: invalid
TODO:
###### ⚠️can ONLY be used 1! time⚠️
TODO:
### 's termination -- depend on -- configuration
TODO:
#### user clicks sign out
TODO:
#### user changes their password OR performs a security sensitive action
TODO:
#### user signs in | ANOTHER device
TODO:
#### times out -- due to -- inactivity
TODO:
#### reaches its maximum lifetime
TODO:
### stored | `auth.sessions` table
TODO:
### deletion life-time
TODO:
#### expiration -- AFTER 24h: deletion
TODO:
##### Reason: 🧠avoid high load | your project🧠
TODO:
# Access token (JWT) claims
TODO:
## access token 's properties
TODO:
### `session_id` claim
TODO:
#### == UUID
TODO:
##### identify UNIQUELY the user's session
TODO:
##### can be correlated -- with the -- primary key of the `auth.sessions` table
TODO:
# Initiating a session
TODO:
## steps
TODO:
### user signs in
TODO:
## session initiation flows
TODO:
### Implicit flow
TODO:
### PKCE flow
TODO:
# limiting session lifetime & number of allowed sessions / EACH user
## ⚠️requirements: Supabase Pro Plans OR better⚠️
* http://127.0.0.1:54323/project/default/auth/sessions
  * does NOT load
### if you want to modify locally -> | "config.toml", set it
* [configured](supabase/config.toml)
* [create an user](sample.http)
  * check the response's `expires_in`:86400
## ways to limit the lifetime of a session
TODO:
### time-boxed sessions
TODO:
#### == AFTER a fixed amount of time, session terminate
TODO:
#### steps to configure it
TODO:
##### | Supabase Studio, \<HOST\>/project/\<PROJECT_NAME\>/auth/sessions
TODO:
### set an inactivity timeout
TODO:
#### == if sessions have NOT been refreshed | timeout duration, session terminate
TODO:
#### steps to configure it
TODO:
##### | Supabase Studio, \<HOST\>/project/\<PROJECT_NAME\>/auth/sessions
TODO:
### Enforce a 1!-session / user OR device OR browser
TODO:
#### == ONLY keeps the MOST recently active session
TODO:
#### steps to configure it
TODO:
##### | Supabase Studio, \<HOST\>/project/\<PROJECT_NAME\>/auth/sessions
TODO:
## | change these settings,
TODO:
### ❌sessions are NOT proactively destroyed❌
TODO:
#### Reason: 🧠| NEXT refresh session, it's enforced🧠
TODO:
## actual duration of a session
TODO:
### == configured timeout + JWT expiration time
TODO:
# Frequently asked questions
TODO:
## What are recommended values for access token (JWT) expiration?
TODO:
## What is refresh token reuse detection and what does it protect from?
TODO:
### reuse interval (default: 10 seconds)
TODO:
#### refresh token can be used more than once within this interval
TODO:
##### use cases
TODO:
###### SSR -- same refresh token reused | server & client
TODO:
###### leeway for bugs serializing access to the refresh token request
TODO:
### if parent of the currently active refresh token is used -> active token returned
TODO:
#### solves: client didn't receive/process the refresh response
TODO:
### outside these exceptions -> session terminated + ALL refresh tokens revoked
TODO:
### purpose: guard against stolen refresh tokens
TODO:
#### ❌does NOT guard against session stolen from device❌
TODO:
## What are the benefits of using access and refresh tokens instead of traditional sessions?
TODO:
### traditional sessions tradeoffs
TODO:
#### auth server crash -> whole app goes down
TODO:
#### failing auth server -> chain of failures across systems
TODO:
#### ALL requests routed through auth -> latency overhead
TODO:
### JWT-based approach advantages
TODO:
#### session info encoded | access token -> NO dependence on central server
TODO:
#### proactive refresh -> app works even during outages
TODO:
#### better cost optimization & scaling
TODO:
## How to ensure an access token (JWT) cannot be used after a user signs out
TODO:
### check `session_id` claim -- corresponds to -- row | `auth.sessions` table
TODO:
#### if row does NOT exist -> user has logged out
TODO:
### ⚠️sessions NOT proactively terminated when time-box / inactivity timeout reached⚠️
TODO:
#### cleaned up progressively 24h after reaching that status
TODO:
## Using HTTP-only cookies to store access and refresh tokens
TODO:
### ONLY feasible | server-only web app (returns rendered HTML only)
TODO:
### ❌NOT feasible if app uses client-side JavaScript❌
TODO:
#### Reason: 🧠browser will NOT have access to access & refresh tokens🧠
TODO:
### override `storage` option | createClient -- on the server --
TODO:
### `customStorageObject` -- must implement -- `getItem`, `setItem`, `removeItem`
TODO:
#### async versions also supported
TODO:
### set `Expires` / `Max-Age` cookie attributes to far future
TODO:
#### let Supabase Auth control token validity
TODO:
#### instruct browser to always store cookies indefinitely
TODO:
