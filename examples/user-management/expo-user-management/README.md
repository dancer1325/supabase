# React Native User Management example with Expo

## Requirements

* [install Expo CLI](https://docs.expo.io/get-started/installation/)

## how to set up?

* [here](../../../apps/docs/content/guides/getting-started/tutorials/with-expo-react-native.md)
* `cp .env.example .env`
  * | ".env",
    * fill your URL & publishable key

## how has it been created?

* [here](../../../apps/docs/content/guides/getting-started/tutorials/with-expo-react-native.md)

## how to run?

```bash
npm install
# OR
# npm install --force

# if you have got file picker 
npm run prebuild

npm start
```

## structure

* [Auth.tsx](components/Auth.tsx)
  * responsible for
    * manage
      * login
      * sign up

## Supabase details

### Postgres Row level security

TODO: 
This project uses very high-level Authorization using Postgres' Row Level Security.
When you start a Postgres database on Supabase, we populate it with an `auth` schema, and some helper functions.
When a user logs in, they are issued a JWT with the role `authenticated` and their UUID.
We can use these details to provide fine-grained control over what each user can and cannot do.

This is a trimmed-down schema, with the policies:

```sql
-- Create a table for Public Profiles
create table
  profiles (
    id uuid references auth.users not null,
    updated_at timestamp
    with
      time zone,
      username text unique,
      avatar_url text,
      website text,
      primary key (id),
      unique (username),
      constraint username_length check (char_length(username) >= 3)
  );

alter table
  profiles enable row level security;

create policy "Public profiles are viewable by everyone." on profiles for
select
  using (true);

create policy "Users can insert their own profile." on profiles for insert
with
  check ((select auth.uid()) = id);

create policy "Users can update own profile." on profiles for
update
  using ((select auth.uid()) = id);

-- Set up Realtime!
begin;

drop
  publication if exists supabase_realtime;

create publication supabase_realtime;

commit;

alter
  publication supabase_realtime add table profiles;

-- Set up Storage!
insert into
  storage.buckets (id, name)
values
  ('avatars', 'avatars');

-- Set up access controls for storage. Allows downloading object with public key
-- See https://supabase.com/docs/guides/storage/security/access-control#policy-examples for more details.
create policy "Avatar images are publicly accessible." on storage.objects for
select
  using (bucket_id = 'avatars' and storage.allow_any_operation(array['object.get_authenticated_info', 'object.get_authenticated']));

create policy "Anyone can upload an avatar." on storage.objects for insert
with
  check (bucket_id = 'avatars');
```
