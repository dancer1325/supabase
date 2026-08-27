# prerequirements
* download Docker Desktop
* `npx supabase init` OR `supabase init`
* `npx supabase start` OR `supabase start`
* | Supabase Dashboard > Authentication > Users > create a New user
    * fill in
        * email
        * password

# Supabase Dashboard > 
## Authentication > Users -> display your current users
* follow the steps
* checked
## Table editor > choose a schema = auth -> - display Auth schema
* follow the steps
* checked

# Accessing user data -- via -- API
TODO:
## ❌Auth schema | auto-generated API, is NOT exposed❌
TODO:
### 🧠security🧠
TODO:
## steps
TODO:
### create your OWN user tables | `public` schema
TODO:
#### protect the table -- by -- enabling Row Level Security
TODO:
#### ONLY granting the necessary privileges / EACH role
TODO:
### reference the `auth.users` table
TODO:
#### 🧠ensure data integrity🧠
TODO:
### | reference, specify `on delete cascade`
TODO:
## primary keys
TODO:
### vs columns OR indices OR constraints OR OTHER database objects / managed -- by -- Supabase
TODO:
#### primary keys: NOT change
TODO:
#### columns OR indices OR constraints: may change | ANY time
TODO:
### uses: as foreign key references | schemas & tables / are managed by Supabase
TODO:
## recommendation: if you want to update a table / EACH user signs up -> set up a trigger
TODO:
### ⚠️if the trigger fails -> it could block signups⚠️
TODO:


# Adding & retrieving user metadata
## user metadata 
### can be assigned | sign up
TODO:
### stored | `raw_user_meta_data` column | `auth.users` table
* check [sample.sql](sample.sql)

# Deleting users
TODO:
## ways to delete an user
TODO:
### -- via -- Supabase Dashboard > Authentication > Users
TODO:
### -- via -- SQL
TODO:
### -- via -- management API
TODO:
## ❌ALTHOUGH you delete an user -> NOT AUTOMATICALLY sign out a user❌
TODO:
### 🧠Supabase uses JWT / remain "valid" TILL being expired🧠
TODO:
## ❌if an user is owner of ANY objects | Supabase Storage -> you can NOT delete the user❌
TODO:
### SOLUTION: delete ALL user's objects
TODO:
### SOLUTION: reassign ownership -- to -- another user
TODO:


# Exporting users
TODO:
## `select * from auth.users;`
TODO:
## export the results -- as -- CSV
TODO:
