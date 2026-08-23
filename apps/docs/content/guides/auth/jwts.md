---
id: 'auth-jwts'
title: 'JSON Web Token (JWT)'
subtitle: 'Information on how best to use JSON Web Tokens with Supabase'
---

* [JSON Web Token](https://jwt.io/introduction)
  * == data structure /
    * represented -- as -- a string

      ```
      <header>.<payload>.<signature>
      ```
        * `<header>`
          * == string of
            * [Base64-URL](https://en.wikipedia.org/wiki/Base64#Variants_summary_table) encoded JSON, OR
            * bytes

              ```json
              {
                "typ": "JWT",
                "alg": "<HS256 | ES256 | RS256>",
                "kid": "<unique key identifier>"
              }
              ```

          * `typ`
            * == type 
          * `alg`
            * == cryptographic algorithm 
            * uses
              * verify the data
          * `kid`
            * OPTIONAL
            * uses
              * | verify it
        * `<payload>`
          * == string of
            * [Base64-URL](https://en.wikipedia.org/wiki/Base64#Variants_summary_table) encoded JSON, OR
            * bytes

          ```json
          {
            "iss": "https://project_id.supabase.co/auth/v1",
            "exp": 12345678,
            "sub": "<user ID>",
            "role": "authenticated",
            "email": "someone@example.com",
            "phone": "+15552368"
            // ...
          }
          ```

          * == claims /
            * == user data + metadata
            * depending on the ones / it contain -> DIFFERENT JWT type
              * Access Token
                * == what the user can access
              * ID Token
                * == who the user is
            * [here](jwt-fields.md)
          * == entity's identifying information
          * [Custom Access Token Hook](auth-hooks/custom-access-token-hook)
        * `<signature>`
          * == string of
            * [Base64-URL](https://en.wikipedia.org/wiki/Base64#Variants_summary_table) encoded JSON, OR
            * bytes
          * == [digital signature](https://en.wikipedia.org/wiki/Digital_signature) -- via --
            * [shared secret](https://en.wikipedia.org/wiki/HMAC) OR
            * [public-key cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography)
          * goal
            * verify -- , WITHOUT relying on database access OR Auth server's liveness & performance, -- the authenticity of the `<header>.<payload>`
          * recommendations
            * 👀rely on `supabase.auth.getClaims()` OR other JWT verification libraries👀
              * -- rather than -- implementing the algorithms yourself

    * contains
      * user's identity
      * user's authorization information
    * encodes information about user's lifetime 
    * is signed -- with -- a cryptographic key
      * Reason:🧠make it tamper-resistant🧠
  * 👀are issued / EACH [user session](sessions.md)👀
    * -- by -- Supabase Auth
    * as long as the user remains signed in
  * provide
    * the foundation -- for -- [Row Level Security](../database/postgres/row-level-security)
  * use cases
    * by any Supabase product
      * BEFORE using Postgres policies & roles,
        * securely decode & verify the validity of a JWT / it receives
        * authorize access -- to -- the project's data

* [JWT Signing Keys](signing-keys)
  * provided by 
    * Supabase
  * allows
    * create JWT
    * verify JWT

## Supabase & JWTs

* use cases 
  * | Supabase creates JWTs
    1. | use Supabase Auth, 
       * access token (JWT) is created / EACH user / remain signed in
         * short lived
           * Reason:🧠CONTINUOUSLY issued / EACH time your user interacts -- with -- Supabase APIs🧠
    2. On-the-fly | use publishable OR secret API keys
       * EACH API key is transformed -- into a -- short-lived JWT /
         * uses
           * authorize access -- to -- your data
         * ❌NORMALLY, NOT possible to access to them❌
  * | Supabase accept JWTs -- from -- OTHER authentication servers,
    * -- via -- [Third-Party Auth](third-party/overview)
    * -- via -- an imported [JWT Signing Key](signing-keys)

## use custom OR third-party JWTs

* `supabase.auth.getClaims()`
  * uses
    * with JWTs / issued -- by -- Supabase Auth

* recommendation
  * use a JWT verification library 

TODO: 
Your Supabase project accepts a JWT in the `Authorization: Bearer <jwt>` header
* If you're using the Supabase client library, it does this for you.

If you are already using Supabase Auth, when a user is signed in, their access token JWT is automatically managed and sent for you with every API call.

If you wish to send a JWT from a Third-Party Auth provider, or one you made yourself by using a JWT signing key you imported, you can pass it to the client library using the `accessToken` option.

In the past there was a recommendation to set custom headers on the Supabase client with the `Authorization` header including your custom JWT
* This is no longer recommended as it's less flexible and causes confusion when combined with a user session from Supabase Auth.

#### TypeScript

```typescript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  'https://<supabase-project>.supabase.co',
  'SUPABASE_PUBLISHABLE_KEY',
  {
    accessToken: async () => {
      return '<your JWT here>'
    },
  }
)
```

#### Flutter (Dart)

```dart
await Supabase.initialize(
  url: supabaseUrl,
  publishableKey: supabaseKey,
  debug: false,
  accessToken: () async {
    return "<your JWT here>";
  },
);
```

#### Swift (iOS)

```swift
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://<supabase-project>.supabase.co")!,
  supabaseKey: "SUPABASE_PUBLISHABLE_KEY",
  options: SupabaseClientOptions(
    auth: SupabaseClientOptions.AuthOptions(
      accessToken: {
        return "<your JWT here>"
      }
    )
  )
)
```

#### Kotlin

```kotlin
val supabase = createSupabaseClient(
    "https://<supabase-project>.supabase.co",
    "SUPABASE_PUBLISHABLE_KEY"
) {
    accessToken = {
        "<your JWT here>"
    }
}
```

#### cURL

```bash
curl 'https://<supabase-project>.supabase.co/rest/v1/my_table?select=id' \
  -H "apikey: $SUPABASE_PUBLISHABLE_KEY" \
  -H "Authorization: Bearer <your JWT here>"
```

## Verify a JWT from Supabase

If you're not able to use the Supabase client libraries, the following can be used to help you securely verify JWTs issued by Supabase.

Supabase Auth exposes a [JSON Web Key](https://datatracker.ietf.org/doc/html/rfc7517) Set URL for each Supabase project:

```http
GET https://project-id.supabase.co/auth/v1/.well-known/jwks.json
```

Which responds with JWKS object containing one or more asymmetric [JWT signing keys](/docs/guides/auth/signing-keys) (only their public keys)
* Be aware that this endpoint does not return any keys if you are not using asymmetric JWT signing keys.

```json
{
  "keys": [
    {
      "kid": "<match with kid from JWT header>",
      "alg": "<match with alg from JWT header>",
      "kty": "<RSA|EC|OKP>",
      "key_ops": ["verify"]
      // public key fields
    }
  ]
}
```

This endpoint is served directly from the Auth server, but is also additionally cached by the Supabase Edge for 10 minutes, 
significantly speeding up access to this data regardless of where you're performing the verification
* It's important to be aware of the cache expiry time to prevent unintentionally rejecting valid user access tokens
* We recommend waiting at least 20 minutes when creating a standby signing key, or revoking a previously used key.

Make sure that you do not cache this data for longer in your application, as it might make revocation difficult
* If you do, make sure to provide a way to purge this cache when rotating signing keys to avoid unintentionally rejecting valid user access tokens.

Below is an example of how to use the [jose TypeScript JWT verification library](https://github.com/panva/jose) with Supabase JWTs:

```typescript
import { createRemoteJWKSet, jwtVerify } from 'jose'

const PROJECT_JWKS = createRemoteJWKSet(
  new URL('https://project-id.supabase.co/auth/v1/.well-known/jwks.json')
)

/**
 * Verifies the provided JWT against the project's JSON Web Key Set.
 */
async function verifyProjectJWT(jwt: string) {
  return jwtVerify(jwt, PROJECT_JWKS)
}
```

### Verifying with a shared secret signing key

If your project is using a shared secret (HS256) signing key, we recommend always verifying a user access token directly
with the Auth server by sending a request like so:

```http
GET https://project-id.supabase.co/auth/v1/user
apikey: publishable key
Authorization: Bearer <JWT>
```

If the server responds with HTTP 200 OK, the JWT is valid, otherwise it is not.

Because the Auth server runs only in your project's specified region and is not globally distributed, 
doing this check can be quite slow depending on where you're performing the check
* Avoid doing checks like this from servers or functions running on the edge, and prefer routing to a server within the same geographical region as your project.

If you are using a shared secret (HS256) signing key, you may wish to verify using the shared secret
* **We strongly recommend against this approach.**

<Admonition type="caution">

There is almost no benefit from using a JWT signed with a shared secret
* Although it's computationally more efficient and verification is simpler to code by hand, 
using this approach can expose your project's data to significant security vulnerabilities or weaknesses.

Consider the following:

- Using a shared secret can make it more difficult to keep aligned with security compliance frameworks such as SOC2, PCI-DSS, ISO27000, HIPAA, etc.
- A shared secret that is in the hands of a malicious actor can be used to impersonate your users, give them access to privileged actions or data.
- It is difficult to detect or identify when or how a shared secret has been given to a malicious actor.
- Consider who might have even accidental access to the shared secret: systems, staff, devices (and their disk encryption and vulnerability patch status).
- A malicious actor can use a shared secret **far into the future**, so lacking current evidence of compromise does not mean your data is secure.
- It can be very easy to accidentally leak the shared secret in publicly available source code such as in your website or frontend, mobile app package or other executable
* This is especially true if you accidentally add the secret in environment variables prefixed with `NEXT_PUBLIC_`, `VITE_`, `PUBLIC_` or other conventions by web frameworks.
- Rotating shared secrets might require careful coordination to avoid downtime of your app.

</Admonition>

Check the JWT verification libraries for your language on how to securely verify JWTs signed with a shared secret (HS256) signing key
* We strongly recommend relying on the Auth server as described above, or switching to a different signing key based on public key cryptography
(RSA, Elliptic Curves) instead.

## Resources

* [JWT debugger](https://jwt.io/) 
* [JWT Signing Keys](signing-keys)
* [JWT Claims Reference](jwt-fields)
* [API keys](../getting-started/api-keys)
