---
id: 'auth-anonymous'
title: 'Anonymous Sign-Ins'
subtitle: 'Create and use anonymous users to authenticate with Supabase'
---

* Anonymous Sign-Ins
  * steps to enable
    * review your EXISTING RLS policies
    * Supabase Dashboard > choose a project > Auth > Providers > enable anonymous sign-ins
  * ❌are NOT tied -- to -- ANY identities❌
    * -> you can NOT sign back -- as -- same user
  * allows
    * build apps /
      * users can have an AUTHENTICATED experience
        * WITHOUT providing
          * any PII (Personally Identifiable Information)
            * _Examples:_ email address, password, ...
          * OAuth provider
        * AFTERWARDS, the user can link -- to -- an authentication method
  * have
    * user ID
    * personalized Access Token
  * use cases
    * | e-commerce applications,
      * BEFORE checkout, to create shopping carts
    * FULL-feature demos / NO collect personal information
    * Temporary or throw-away accounts

* anonymous user
  * ❌!= [`anon`](../database/postgres/roles.md#anon)❌
  * steps to create
    * call `signInAnonymously()`
  * vs [authenticated user](../database/postgres/roles.md#authenticated)
    * ❌if the anonymous user sign out OR clear browsing data OR use ANOTHER device -> anonymous user can NOT access their account❌
  * 's JWT
    * `.is_anonymous` claim
      * allows
        * 👀| RLS policies, distinguish anonymous users vs authenticated users👀
    * 👀== `auth.jwt()`'s return👀
  * access -- , via [`authenticated` role](../database/postgres/roles.md#authenticated), to -- the database 
  * PROBLEMS
    * PROBLEM1: | frameworks / use static page rendering -> user metada is cached | UNIQUE anonymous users
      * _Example:_ Next.js
      * SOLUTION: use dynamic page rendering

TODO:

<Admonition type="note" title="Self hosting and local development">

For self-hosting, you can update your project configuration using the files and environment variables provided
* See the [local development docs](/docs/guides/cli/config) for more details.

</Admonition>

## Sign in anonymously

* `supabase.auth.sign_in_anonymously()`

## Convert an anonymous user -- to -- a permanent user

* ⚠️requirements ⚠️ 
  * Supabase Dashboard > choose your Supabase project > Authentication > Providers > enable MANUAL linking 
  * [link an identity -- to -- the user](auth-identity-linking#manual-linking-beta)

### link an email OR phone identity -- to -- anonymous user

* `supabase.auth.updateUser()` / `supabase.auth.update_user()`

* ONCE user's email OR phone number is verified -> you can add anonymous user's password

### Link an OAuth identity

* `supabase.auth.linkIdentity()` / `supabase.auth.link_identity()`

## Access control

TODO:

<Admonition type="note" title="Use restrictive policies">

RLS policies are permissive by default, which means that they are combined using an "OR" operator 
when multiple policies are applied
* It is important to construct restrictive policies to ensure that the checks for an anonymous user 
are always enforced when combined with other policies.
Be aware that a single 'restrictive' RLS policy alone will fail unless combined with another policy that returns true, 
ensuring the combined condition is met.

</Admonition>

## Resolving identity conflicts

Depending on your application requirements, data conflicts can arise when an anonymous user is converted 
to a permanent user
* For example, in the context of an e-commerce application, 
an anonymous user would be allowed to add items to the shopping cart without signing up / signing in
* When they decide to sign-in to an existing account, you will need to decide how you want to resolve data conflicts in the shopping cart:

1. Overwrite the items in the cart with those in the existing account
2. Overwrite the items in the cart with those from the anonymous user
3. Merge the items in the cart together

### Linking an anonymous user to an existing account

In some cases, you may need to link an anonymous user to an existing account rather than creating a new permanent account
* This process requires manual handling of potential conflicts
* Here's a general approach:

```javascript
// 1. Get the current session and verify the user is anonymous
const { data: anonData, error: anonError } = await supabase.auth.getSession()

if (!anonData.session?.user?.is_anonymous) {
  console.log('User is not anonymous. This flow only applies to anonymous users.')
  return
}

// 2. Attempt to update the user with the existing email
const { data: updateData, error: updateError } = await supabase.auth.updateUser({
  email: 'valid.email@supabase.io',
})

// 3. Handle the error (since the email belongs to an existing user)
if (updateError) {
  console.log('This email belongs to an existing user. Please sign in to that account.')

  // 4. Sign in to the existing account
  const {
    data: { user: existingUser },
    error: signInError,
  } = await supabase.auth.signInWithPassword({
    email: 'valid.email@supabase.io',
    password: 'user_password',
  })

  if (existingUser) {
    // 5. Reassign entities tied to the anonymous user
    // This step will vary based on your specific use case and data model
    const { data: reassignData, error: reassignError } = await supabase
      .from('your_table')
      .update({ user_id: existingUser.id })
      .eq('user_id', anonData.session.user.id)

    // 6. Implement your chosen conflict resolution strategy
    // This could involve merging data, overwriting, or other custom logic
    await resolveDataConflicts(anonData.session.user.id, existingUser.id)
  }
}

// Helper function to resolve data conflicts (implement based on your strategy)
async function resolveDataConflicts(anonymousUserId, existingUserId) {
  // Implement your conflict resolution logic here
  // This could involve ignoring the anonymous user's metadata, overwriting the existing user's metadata, or merging the data of both the anonymous and existing user.
}
```

## Abuse prevention and rate limits

Since anonymous users are stored in your database, bad actors can abuse the endpoint to increase your database size drastically
* It is strongly recommended to [enable invisible CAPTCHA or Cloudflare Turnstile](/docs/guides/auth/auth-captcha) to prevent abuse for anonymous sign-ins
* An IP-based rate limit is enforced at 30 requests per hour which can be modified in your [dashboard](/dashboard/project/_/auth/rate-limits)
* You can refer to the full list of rate limits [here](/docs/guides/platform/going-into-prod#rate-limiting-resource-allocation--abuse-prevention).

## Automatic cleanup

Automatic cleanup of anonymous users is currently not available
* Instead, you can delete anonymous users from your project by running the following SQL:

```sql
-- deletes anonymous users created more than 30 days ago
delete from auth.users
where is_anonymous is true and created_at < now() - interval '30 days';
```

## Resources

- [Supabase - Get started for free](https://supabase.com)
- [Supabase JS Client](https://github.com/supabase/supabase-js)
- [Supabase Flutter Client](https://github.com/supabase/supabase-flutter)
- [Supabase Kotlin Client](https://github.com/supabase-community/supabase-kt)
