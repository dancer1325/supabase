---
id: 'auth-identity-linking'
title: 'Identity Linking'
description: 'Manage the identities associated with your user'
subtitle: 'Manage the identities associated with your user'
---

## Identity linking strategies

* 💡strategies / link an identity -- to a -- user💡
  * supported by Supabase Auth 
    1. [AUTOMATIC Linking](#automatic-linking)
    2. [MANUAL Linking](#manual-linking-beta)
  * ⚠️EXCEPT TO,
    * users / signed up -- with -- [SAML SSO](enterprise-sso/auth-sso-saml)⚠️
      * Reason:🧠security reasons🧠

### Automatic linking

Supabase Auth automatically links identities with the same email address to a single user
* This helps to improve the user experience when multiple OAuth login options are presented since the user does not need to remember
which OAuth account they used to sign up with
* When a new user signs in with OAuth, Supabase Auth will attempt to look for an existing user that uses the same email address
* If a match is found, the new identity is linked to the user.

In order for automatic linking to correctly identify the user for linking, Supabase Auth needs to ensure that all user emails are unique
* It would also be an insecure practice to automatically link an identity to a user with an unverified email address since that could lead 
to pre-account takeover attacks
* To prevent this from happening, when a new identity can be linked to an existing user, Supabase Auth will remove any other unconfirmed identities 
linked to an existing user.

### Manual linking (beta)

* Supabase Auth allows a user to initiate identity linking -- with -- a different email address | logged in

#### JavaScript

* To link an OAuth identity to the user, call [`linkIdentity()`](/docs/reference/javascript/auth-linkidentity):

```js
const { data, error } = await supabase.auth.linkIdentity({ provider: 'google' })
```

#### Dart

* To link an OAuth identity to the user, call [`linkIdentity()`](/docs/reference/dart/auth-linkidentity):

```dart
await supabase.auth.linkIdentity(OAuthProvider.google);
```

#### Swift

* To link an OAuth identity to the user, call [`linkIdentity()`](/docs/reference/swift/auth-linkidentity):

```swift
try await supabase.auth.linkIdentity(provider: .google)
```

#### Kotlin

* To link an OAuth identity to the user, call [`linkIdentity()`](/docs/reference/kotlin/auth-linkidentity):

```kotlin
supabase.auth.linkIdentity(Google)
```

#### Python

* To link an OAuth identity to the user, call [`link_identity()`](/docs/reference/python/auth-linkidentity):

```python
response = supabase.auth.link_identity({'provider': 'google'})
```

* | the example above,
  * user -- will be redirected to -- Google -- to complete the -- OAuth2.0 flow
  * | OAuth2.0 flow completed successfully,
    * user -- will be redirected back to -- the application
    * Google identity -- will be linked to -- the user
* enable manual linking
  * | Supabase Dashboard > [Auth > Providers > configuration options](/dashboard/project/_/auth/providers)
  * | self-hosting: set env var `GOTRUE_SECURITY_MANUAL_LINKING_ENABLED: true`

### Link identity with native OAuth (ID token)

#### JavaScript

* | native mobile apps, link an identity -- using -- an ID token / obtained from a third-party OAuth provider
  * uses
    * native OAuth flows (Google Sign-In, Sign in with Apple) rather than web-based OAuth redirects

```js
// Example with Google Sign-In (using a native Google Sign-In library)
const idToken = 'ID_TOKEN_FROM_GOOGLE'
const accessToken = 'ACCESS_TOKEN_FROM_GOOGLE'

const { data, error } = await supabase.auth.linkIdentity({
  provider: 'google',
  token: idToken,
  access_token: accessToken,
})
```

#### Dart

* | Flutter apps, link an identity -- using -- an ID token / obtained from native OAuth packages
  * _Examples:_ `google_sign_in`, `sign_in_with_apple`
  * call [`linkIdentityWithIdToken()`](/docs/reference/dart/auth-linkidentitywithidtoken)
  * supports same OAuth providers as `signInWithIdToken()`: Google, Apple, Facebook, Kakao, Keycloak

```dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// First, obtain the ID token from the native provider
final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: iosClientId,
  serverClientId: webClientId,
);
final googleUser = await googleSignIn.signIn();
final googleAuth = await googleUser!.authentication;

// Link the Google identity to the current user
final response = await supabase.auth.linkIdentityWithIdToken(
  provider: OAuthProvider.google,
  idToken: googleAuth.idToken!,
  accessToken: googleAuth.accessToken!,
);
```

## Unlink an identity

* ⚠️requirements⚠️
  * user logged in
  * user has AT LEAST 2 linked identities

### JavaScript

* [`getUserIdentities()`](/docs/reference/javascript/auth-getuseridentities) -- to fetch -- ALL identities linked to a user
* [`unlinkIdentity()`](/docs/reference/javascript/auth-unlinkidentity) -- to unlink -- the identity

```js
// retrieve all identities linked to a user
const { data: identities, error: identitiesError } = await supabase.auth.getUserIdentities()

if (!identitiesError) {
  // find the google identity linked to the user
  const googleIdentity = identities.identities.find((identity) => identity.provider === 'google')

  if (googleIdentity) {
    // unlink the google identity from the user
    const { data, error } = await supabase.auth.unlinkIdentity(googleIdentity)
  }
}
```

### Dart

* [`getUserIdentities()`](/docs/reference/dart/auth-getuseridentities) -- to fetch -- ALL identities linked to a user
* [`unlinkIdentity()`](/docs/reference/dart/auth-unlinkidentity) -- to unlink -- the identity

```dart
// retrieve all identities linked to a user
final List<UserIdentity> identities = await supabase.auth.getUserIdentities();

// find the google identity linked to the user
final UserIdentity googleIdentity =
    identities.singleWhere((identity) => identity.provider == 'google');

// unlink the google identity from the user
await supabase.auth.unlinkIdentity(googleIdentity);
```

### Swift

* [`getUserIdentities()`](/docs/reference/swift/auth-getuseridentities) -- to fetch -- ALL identities linked to a user
* [`unlinkIdentity()`](/docs/reference/swift/auth-unlinkidentity) -- to unlink -- the identity

```swift
// retrieve all identities linked to a user
let identities = try await supabase.auth.userIdentities()

// find the google identity linked to the user
let googleIdentity = identities.first { $0.provider == .google }

// unlink the google identity from the user
try await supabase.auth.unlinkIdentity(googleIdentity)
```

### Kotlin

* [`currentIdentitiesOrNull()`](/docs/reference/kotlin/auth-getuseridentities) -- to get -- ALL identities linked to a user
* [`unlinkIdentity()`](/docs/reference/kotlin/auth-unlinkidentity) -- to unlink -- the identity

```kotlin
//get all identities linked to a user
val identities = supabase.auth.currentIdentitiesOrNull() ?: emptyList()

//find the google identity linked to the user
val googleIdentity = identities.first { it.provider == "google" }

//unlink the google identity from the user
supabase.auth.unlinkIdentity(googleIdentity.identityId!!)
```

### Python

* [`get_user_identities()`](/docs/reference/python/auth-getuseridentities) -- to fetch -- ALL identities linked to a user
* [`unlink_identity()`](/docs/reference/python/auth-unlinkidentity) -- to unlink -- the identity

```python
# retrieve all identities linked to a user
response = supabase.auth.get_user_identities()

# find the google identity linked to the user
google_identity = next((identity for identity in response.identities if identity.provider == 'google'), None)

# unlink the google identity from the user
if google_identity:
    response = supabase.auth.unlink_identity(google_identity.identity_id)
```

## Frequently asked questions

### How to add email/password login to an OAuth account?

Call the `updateUser({ password: 'validpassword'})` to add email with password authentication to an account created with an OAuth provider (Google, GitHub, etc.).

### Can you sign up with email if already using OAuth?

If you try to create an email account after previously signing up with OAuth using the same email, you'll receive an obfuscated user response with no verification email sent
* This prevents user enumeration attacks.
