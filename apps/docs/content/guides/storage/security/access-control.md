---
id: 'storage-access-control'
title: 'Storage Access Control'
description: 'Learn how to restrict Supabase file uploads.'
sidebar_label: 'Uploads'
tocVideo: '4ERX__Y908k'
---

* storage restriction access
  * -- thanks to -- [Row Level Security (RLS)](../../database/postgres/row-level-security) 

## Access policies

* Supabase Storage
  * by default,
    * does NOT allow ANY uploads | buckets
      * Reason:🧠NOT contain RLS policies🧠
  * if you want to enable certain operations -> create RLS policies | `storage.objects` table
    * _Example:_ if you want to 
      * upload objects -> grant the `INSERT` permission | `storage.objects` table
      * overwrite files (== `upsert`) -> grant `SELECT` & `UPDATE` permissions
  * ['s schema](../schema/design)
  * if you want to simplify the process of crafting your policies -> use the [helper functions](../schema/helper-functions) 
    * _Example:_ if you need DIFFERENT `SELECT` policies / DIFFERENT Storage actions (_Example:_ listing objects vs reading authenticated objects) -> use
      * `storage.allow_only_operation()`
      * `storage.allow_any_operation()`

## Policy examples


TODO: 
This example demonstrates how you would allow authenticated users 
to upload files to a folder called `private` inside `my_bucket_id`:

```sql
create policy "Allow authenticated uploads"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'my_bucket_id' and
  (storage.foldername(name))[1] = 'private'
);
```

This example demonstrates how you would allow authenticated users to upload files 
to a folder called with their `users.id` 
inside `my_bucket_id`:

```sql
create policy "Allow authenticated uploads"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'my_bucket_id' and
  (storage.foldername(name))[1] = (select auth.jwt()->>'sub')
);
```

Allow a user to access a file that was previously uploaded by the same user:

```sql
create policy "Individual user Access"
on storage.objects for select
to authenticated
using ( (select auth.jwt()->>'sub') = owner_id );
```

Allow anyone to access objects in the `avatars` bucket via publishable key
* The `allow_any_operation()` filter is critical here as without it users would be able 
to list the bucket contents.

<Admonition type="note">

This is not needed for public buckets, as they are already publicly accessible

</Admonition>

```sql
create policy "Avatar images are publicly accessible." on storage.objects
  for select using (bucket_id = 'avatars' and storage.allow_any_operation(array['object.get_authenticated_info', 'object.get_authenticated']));
```

## Bypassing access controls

* == bypass the RLS policies
* use cases
  * you ONLY use Storage -- from -- trusted clients (_Example:_ your own servers)

* Service keys
  * grant unrestricted access | ALL Storage APIs
  * steps to use
    * | `Authorization` header,
      * add `service key`
