---
id: 'user-management'
title: 'User Management'
subtitle: 'View, delete, and export user information.'
---

* Supabase Dashboard > 
  * Authentication > Users
    * display your current users
  * Table editor > choose a schema
    * display Auth schema

## Accessing user data -- via -- API

* Auth schema 
  * ❌| auto-generated API, is NOT exposed❌
    * Reason:🧠security🧠

* steps
  * create your OWN user tables | `public` schema /
    * protect the table -- by --
      * enabling [Row Level Security](../database/postgres/row-level-security)
      * ONLY granting the necessary privileges / EACH role
  * reference the `auth.users` table
    * Reason:🧠ensure data integrity🧠
  * | reference, specify `on delete cascade` 

* primary keys
  * vs columns OR indices OR constraints OR OTHER database objects / managed -- by -- Supabase
    * change
      * primary keys
        * NOT change
      * columns OR indices OR constraints OR OTHER database objects / managed -- by -- Supabase
        * may change | ANY time
  * uses
    * as [foreign key references](https://www.postgresql.org/docs/current/tutorial-fk.html) | schemas & tables / are managed by Supabase

* recommendation
  * if you want to update a table / EACH user signs up -> set up a trigger
    * ⚠️if the trigger fails -> it could block signups⚠️

## Adding and retrieving user metadata

* user metadata
  * can be assigned | sign up
  * stored | `raw_user_meta_data` column | `auth.users` table

### JavaScript

```js
const { data, error } = await supabase.auth.signUp({
  email: 'valid.email@supabase.io',
  password: 'example-password',
  options: {
    data: {
      first_name: 'John',
      age: 27,
    },
  },
})
```

```js
const {
  data: { user },
} = await supabase.auth.getUser()
let metadata = user?.user_metadata
```

### Dart

```dart
final res = await supabase.auth.signUp(
  email: 'valid.email@supabase.io',
  password: 'example-password',
  data: {
    'first_name': 'John',
    'age': 27,
  },
);
```

```dart
final User? user = supabase.auth.currentUser;
final Map<String, dynamic>? metadata = user?.userMetadata;
```

### Swift

```swift
try await supabase.auth.signUp(
  email: "valid.email@supabase.io",
  password: "example-password",
  data: [
    "first_name": .string("John"),
    "age": .integer(27),
  ]
)
```

```swift
let user = try await supabase.auth.user()
let metadata = user.userMetadata
```

### Kotlin

```kotlin
val data = supabase.auth.signUpWith(Email) {
    email = "valid.email@supabase.io"
    password = "example-password"
    data = buildJsonObject {
        put("first_name", "John")
        put("age", 27)
    }
}
```

```kotlin
val user = supabase.auth.retrieveUserForCurrentSession()
//Or you can use the user from the current session:
val user = supabase.auth.currentUserOrNull()
val metadata = user?.userMetadata
```

## Deleting users

You may delete users directly or via the management console at Authentication > Users
* Note that deleting a user from the `auth.users` table does not automatically sign out a user
* As Supabase makes use of JSON Web Tokens (JWT), a user's JWT will remain "valid" until it has expired.

<Admonition type="caution">

You cannot delete a user if they are the owner of any objects in Supabase Storage.

You will encounter an error when you try to delete an Auth user that owns any Storage objects
* If this happens, try deleting all the objects for that user, or reassign ownership to another user.

</Admonition>

## Exporting users

As Supabase is built on top of Postgres, you can query the `auth.users` and `auth.identities` table via the `SQL Editor` tab to extract all users:

```sql
select * from auth.users;
```

You can then export the results as CSV.
