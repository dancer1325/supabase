# prerequirements
* download Docker Desktop
* `npx supabase init` OR `supabase init`
* `npx supabase start` OR `supabase start`
* | Supabase Dashboard > Authentication > Users > create a New user
  * fill in 
    * email
    * password

# user | Supabase Auth
## == someone / 
### has user ID 
* http://127.0.0.1:54323/project/default/
  * \> Authentication > Users 
    * check ALL users have an UID
### stored | Auth schema
* http://127.0.0.1:54323/project/default/ > Table editor > switch schema to auth > click users
## allows: issue an Access Token / ⚠️tied -- to -- the  user⚠️
TODO:
### -> if you want to restrict access to resources -> via RLS policies
TODO:

# permanent users & anonymous users
## Permanent users
TODO:
### are tied -- to a -- piece of Personally Identifiable Information (PII)
TODO:
#### _Examples:_ email address, a phone number, or a third-party identity
TODO:
#### allows
TODO:
##### AFTER signing out, signing back | their account
TODO:
## Anonymous users
TODO:

# `user` object
TODO:
## stores ALL user's information | your application
TODO:
## ways to be retrieved
TODO:
### `supabase.auth.getUser()`
TODO:
### `supabase.auth.admin.getUserById()`
TODO:
## ways to sign in
TODO:
### Password-based method
TODO:
#### supported by email
TODO:
#### supported by phone
TODO:
### Passwordless method
TODO:
#### supported by email
TODO:
#### supported by phone
TODO:
### OAuth
TODO:
### SAML SSO
TODO:
## requirements to be able to sign in
TODO:
### by default, verified email OR phone number
TODO:
## 's attributes
TODO:
### id -- user's unique id
TODO:
### aud -- audience claim
TODO:
### role -- role claim / uses: Postgres RLS checks
TODO:
### email -- user's email address
TODO:
### email_confirmed_at -- timestamp | user's email was confirmed
TODO:
#### ❌null == user's email is NOT confirmed❌
TODO:
### phone -- user's phone number
TODO:
### phone_confirmed_at -- timestamp | user's phone was confirmed
TODO:
#### ❌null == user's phone is NOT confirmed❌
TODO:
### confirmed_at -- timestamp | user's email OR phone was confirmed
TODO:
### last_sign_in_at -- timestamp | user last signed in
TODO:
### app_metadata
TODO:
#### `.provider` -- first provider / user used to sign up with
TODO:
#### `.providers` -- list of providers / user can use to login with
TODO:
### user_metadata
TODO:
#### by default, the FIRST provider's identity data
TODO:
#### can contain ADDITIONAL CUSTOM user metadata
TODO:
#### ❌NOT rely on this field's order❌
TODO:
#### ❌NOT use it | security sensitive context❌
TODO:
##### Reason: 🧠this value is -- by the user, WITHOUT any checks -- editable🧠
TODO:
### identities -- identities / linked -- to -- the user
TODO:
### created_at -- timestamp | user was created
TODO:
### updated_at -- timestamp | user was last updated
TODO:
### is_anonymous -- true if the user is an anonymous user
TODO:
## identity
TODO:
### == authentication method / user can sign in
TODO:
### 👀there can be >=1 identity / user👀
TODO:
### supported types
TODO:
#### Email
TODO:
#### Phone
TODO:
#### OAuth
TODO:
#### SAML
TODO:

# inviting users

TODO: | take notes, ask steering Kiro to create
