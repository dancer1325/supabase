---
id: 'user-management'
title: 'User Management'
subtitle: 'View, delete, and export user information.'
---

* Supabase Dashboard > 
  * Authentication > Users
    * display your current users
  * Table editor > choose a schema = auth
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

## Adding & retrieving user metadata

* user metadata
  * can be assigned | sign up
  * stored | `raw_user_meta_data` column | `auth.users` table

## Deleting users

* ways to delete an user
  * -- via -- Supabase Dashboard > Authentication > Users
  * -- via -- SQL
  * -- via -- management API

* ❌ALTHOUGH you delete an user -> NOT AUTOMATICALLY sign out a user❌
  * Reason:🧠Supabase uses JWT / remain "valid" TILL being expired🧠

* ❌if an user is owner of ANY objects | Supabase Storage -> you can NOT delete the user❌
  * SOLUTIONS:
    * delete ALL user's objects OR
    * reassign ownership -- to -- another user

## Exporting users

* steps
  * `select * from auth.users;`
  * export the results -- as -- CSV
