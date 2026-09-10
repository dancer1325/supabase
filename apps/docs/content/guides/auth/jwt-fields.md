---
id: 'jwt-fields'
title: 'JWT Claims Reference'
subtitle: 'Complete reference for claims appearing in JWTs created by Supabase Auth'
---

* goal
  * Supabase authentication tokens' ALL JWT claims
    * uses
      * [server-side](server-side.md) JWT validation & serialization
        * _Examples:_ | implement authentication | languages (Rust) / `ref` are reserved keywords

## JWT structure

* [here](jwts.md)

## REQUIRED claims

* == present | ALL Supabase JWTs
* == ❌can NOT be removed❌

| Field          | Type                 | Description                                                        | Example                                       |
| -------------- | -------------------- |--------------------------------------------------------------------|-----------------------------------------------|
| `iss`          | `string`             | **Issuer**                                                         | `"https://project-ref.supabase.co/auth/v1"`   |
| `aud`          | `string \| string[]` | **Audience** <br/> == JWT's intended recipient                     | `"authenticated"` OR `"anon"`                 |
| `exp`          | `number`             | **Expiration Time** <br/> == Unix timestamp \| token expires       | `1640995200`                                  |
| `iat`          | `number`             | **Issued At**  <br/> == Unix timestamp                             | token was issued                              | `1640991600`                                  |
| `sub`          | `string`             | **Subject** <br/> == user's unique ID (UUID)                       | `"123e4567-e89b-12d3-a456-426614174000"`      |
| `role`         | `string`             | **Role**                                                           | `"authenticated"`, `"anon"`, `"service_role"` |
| `aal`          | `string`             | **Authenticator Assurance Level** <br/> == Authentication strength | `"aal1"`, `"aal2"`                            |
| `session_id`   | `string`             | **Session ID**                                                     | `"session-uuid"`                              |
| `email`        | `string`             | **Email** <br/> User's email address                               | `"user@example.com"`                          |
| `phone`        | `string`             | **Phone** <br/> User's phone number                                | `"+1234567890"`                               |
| `is_anonymous` | `boolean`            | **Anonymous Flag** <br/> Whether the user is anonymous             | `false`                                       |

### `iss`

* == server / issued the token
* `"<iss_value>/.well-known/jwks.json"`
  * display
    * public keys with / you can verify the token

### `role`

* == Postgres role
* == user's role | system
* uses
  * | Postgres RLS checks

### `session_id`

* can be correlated -- with the -- `auth.sessions` table's primary key

## OPTIONAL claims

* they appear -- depending on -- the authentication context

| Field           | Type     | Description                                                                | Example                                             |
| --------------- | -------- | -------------------------------------------------------------------------- | --------------------------------------------------- |
| `jti`           | `string` | **JWT ID** - Unique identifier for the JWT                                 | `"jwt-uuid"`                                        |
| `nbf`           | `number` | **Not Before** - Unix timestamp before which the token is invalid          | `1640991600`                                        |
| `app_metadata`  | `object` | **App Metadata** - Application-specific user data                          | `{"provider": "email"}`                             |
| `user_metadata` | `object` | **User Metadata** - User-specific data                                     | `{"name": "John Doe"}`                              |
| `amr`           | `array`  | **Authentication Methods Reference** - List of authentication methods used | `[{"method": "password", "timestamp": 1640991600}]` |

## Special claims

| Field | Type     | Description                                         | Example                  | Context                       |
| ----- | -------- | --------------------------------------------------- | ------------------------ | ----------------------------- |
| `ref` | `string` | **Project Reference** - Supabase project identifier | `"abcdefghijklmnopqrst"` | Anon/Service role tokens only |

## Field value constraints

### Authenticator assurance level (`aal`)

| Value    | Description                                          |
| -------- | ---------------------------------------------------- |
| `"aal1"` | Single-factor authentication (password, OAuth, etc.) |
| `"aal2"` | Multi-factor authentication (password + TOTP, etc.)  |

### Role values (`role`)

| Value             | Description        | Use Case                            |
| ----------------- | ------------------ | ----------------------------------- |
| `"anon"`          | Anonymous user     | Public access with RLS policies     |
| `"authenticated"` | Authenticated user | Standard user access                |
| `"service_role"`  | Service role       | Admin privileges (server-side only) |

### Audience values (`aud`)

| Value             | Description                   |
| ----------------- | ----------------------------- |
| `"authenticated"` | For authenticated user tokens |
| `"anon"`          | For anonymous user tokens     |

### Authentication methods (`amr.method`)

| Value             | Description                   |
| ----------------- | ----------------------------- |
| `"oauth"`         | OAuth provider authentication |
| `"password"`      | Email/password authentication |
| `"otp"`           | One-time password             |
| `"totp"`          | Time-based one-time password  |
| `"recovery"`      | Account recovery              |
| `"invite"`        | Invitation-based signup       |
| `"sso/saml"`      | SAML single sign-on           |
| `"magiclink"`     | Magic link authentication     |
| `"email/signup"`  | Email signup                  |
| `"email_change"`  | Email change                  |
| `"token_refresh"` | Token refresh                 |
| `"anonymous"`     | Anonymous authentication      |

## Validation guidelines | your server

1. [**Check Required Fields**](#required-claims)
2. **Validate Types**
   * == field types == expected types
3. **Check Expiration**
   * == `exp` timestamp is | future
4. **Verify Issuer**
   * == `iss` == your Supabase project
5. **Check Audience**
   * == `aud` == expected audience
6. **Handle Reserved Keywords**
   * _Example:_ | Rust, rename `ref` 

## Security considerations

- **Always validate the JWT signature** before trusting any claims
- **Never expose service role tokens** to client-side code
- **Validate all claims** before trusting the JWT
- **Check token expiration** on every request
- **Use HTTPS** for all JWT transmission
- **Rotate JWT secrets** regularly
- **Implement proper error handling** for invalid tokens
