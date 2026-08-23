---
title: 'Users'
---

* **user** | Supabase Auth
  * == someone /
    * has user ID
    * stored | Auth schema
  * allows
    * issue an [Access Token](jwts.md) / ⚠️tied -- to -- the  user⚠️ 
      * -> if you want to restrict access to resources -> via [RLS policies](../database/postgres/row-level-security)

## permanent users & anonymous users

* **Permanent users**
  * are tied -- to a -- piece of Personally Identifiable Information (PII)
    * _Examples:_ email address, a phone number, or a third-party identity
    * allows
      * AFTER signing out, signing back | their account 
* [**Anonymous users**](auth-anonymous)

## `user` object

* `user` object
  * stores ALL user's information | your application
  * ways to 
    * be retrieved
      1. [`supabase.auth.getUser()`](../../../../reference/javascript/auth-getuser)
      2. [`supabase.auth.admin.getUserById()`](/docs/reference/javascript/auth-admin-listusers)
    * sign in
      * Password-based method
        * supported by
          * email
          * phone
      * Passwordless method
        * supported by
          * emaild
          * phone
      * OAuth
      * SAML SSO
  * requirements to be able to sign in
    * by default, verified
      * email OR
      * phone number
  * 's attributes

| Attributes         | Type             | Description                                                                                                                                                                                                                                                                                                                                                                                              |
| ------------------ | ---------------- |----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id                 | `string`         | user's unique id                                                                                                                                                                                                                                                                                                                                                                                         |
| aud                | `string`         | == audience claim                                                                                                                                                                                                                                                                                                                                                                                        |
| role               | `string`         | == role claim / <br/> &nbsp;&nbsp; uses: Postgres can perform Row Level Security (RLS) checks                                                                                                                                                                                                                                                                                                            |
| email              | `string`         | == user's email address                                                                                                                                                                                                                                                                                                                                                                                  |
| email_confirmed_at | `string`         | == timestamp \| user's email was confirmed <br/> ❌null == user's email is NOT confirmed❌                                                                                                                                                                                                                                                                                                                 |
| phone              | `string`         | user's phone number                                                                                                                                                                                                                                                                                                                                                                                      |
| phone_confirmed_at | `string`         | == timestamp \| user's phone was confirmed <br/> ❌null == user's phone is NOT confirmed ❌                                                                                                                                                                                                                                                                                                                |
| confirmed_at       | `string`         | == timestamp \| user's email OR phone was confirmed <br/> null == user's email is NOT confirmed & user's phone is NOT confirmed❌                                                                                                                                                                                                                                                                         |
| last_sign_in_at    | `string`         | == timestamp \| user last signed in                                                                                                                                                                                                                                                                                                                                                                      |
| app_metadata       | `object`         | `.provider` <br/> &nbsp;&nbsp; == first provider / user used to sign up with <br/> `.providers` <br/> &nbsp;&nbsp; == list of providers / user can use to login with                                                                                                                                                                                                                                     |
| user_metadata      | `object`         | by default, the FIRST provider's identity data <br/> if it's specified, it can contain ADDITIONAL CUSTOM user metadata <br/> [MORE](auth-identity-linking.md) <br/> ❌NOT rely on this field's order❌ <br/> ❌NOT use it \| security sensitive context (_Examples:_ RLS policies or authorization logic) ❌<br/> &nbsp;&nbsp; Reason: 🧠this value is -- , by the user, WITHOUT any checks, -- editable 🧠 |
| identities         | `UserIdentity[]` | == identitieS / linked -- to -- the user                                                                                                                                                                                                                                                                                                                                                                 |
| created_at         | `string`         | == timestamp \| user was created                                                                                                                                                                                                                                                                                                                                                                         |
| updated_at         | `string`         | == timestamp \| user was last updated                                                                                                                                                                                                                                                                                                                                                                    |
| is_anonymous       | `boolean`        | if the user is an anonymous user -> true                                                                                                                                                                                                                                                                                                                                                                 |

* identity
  * == authentication method / 
    * uses
      * user can sign in
  * 👀there can be >=1 identity / user👀
  * supported types
    * Email
    * Phone
    * OAuth
    * SAML

## inviting users

TODO: 
You can invite someone to create an account by sending them an invitation email
* The invited user receives an email containing a link that, when clicked, 
confirms their email address and lets them finish setting up their account (for example, by setting a password).

Inviting a user is an admin action, so it must be performed from a trusted server environment using your secret key, or 
from the Dashboard
* When you invite an email that doesn't yet belong to a user, a new unconfirmed user is created
* Inviting an email that already belongs to a confirmed user returns an error.

### Using the Dashboard

1. Go to **Authentication > Users** in the Dashboard.
2. Click **Add user** and select **Send invitation**.
3. Enter the user's email address and click **Invite user**.

{/* supa-mdx-lint-disable-next-line Rule001HeadingCase */}

### Using the Auth Admin API

Call [`inviteUserByEmail()`](/docs/reference/javascript/auth-admin-inviteuserbyemail) from the SDK's Auth Admin API in a server-side environment
* This is part of Supabase Auth (accessed via `supabase.auth.admin` with your project's [secret key](/docs/guides/getting-started/api-keys)), and
is distinct from the [Management API](/docs/reference/api/introduction) used to configure your project
* You can optionally attach custom `user_metadata` and a redirect URL for the invite link.

```js
import { createClient } from '@supabase/supabase-js'

// Use your project's secret key (sb_secret_...), and only ever on a trusted server.
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SECRET_KEY, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
    detectSessionInUrl: false,
  },
})

const { data, error } = await supabase.auth.admin.inviteUserByEmail('someone@example.com', {
  data: { name: 'Jane' }, // optional, stored in user_metadata
  redirectTo: 'https://example.com/welcome', // optional, where the invite link sends the user
})
```

<Admonition type="caution">

The secret key (`sb_secret_...`, which replaces the legacy `service_role` key) bypasses Row Level Security and must only be used
in a secure server environment
* Never expose it in a browser or any publicly accessible client.

</Admonition>

<Admonition type="note">

The `redirectTo` URL must be in your project's [allowed redirect URLs](/docs/guides/auth/redirect-urls) configuration
* If it isn't, the `redirectTo` value is ignored and the invite link redirects to your Site URL instead (no error is raised).

</Admonition>

The invitation email uses the **Invite user** email template, which you can customize
* Refer to [Email Templates](/docs/guides/auth/auth-email-templates) to learn more.

<Admonition type="caution">

Invitation links expire after the duration configured in [Email OTP Expiration](/dashboard/project/_/auth/providers?provider=Email), which defaults to 1 hour
* This is the same value used for [email OTPs](/docs/guides/auth/auth-email-passwordless#enabling-email-otp), magic links, and other email confirmation links
* If an invitation expires before it's accepted, send the user a new invite.

</Admonition>

## MORE

* [User Management guide](managing-user-data)
