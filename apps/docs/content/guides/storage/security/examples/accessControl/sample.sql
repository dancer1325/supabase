--  goal: create INSER RLS policy / restrict them -- to -- meet your security requirements

create policy "policy_name"
ON storage.objects
for insert with check (
  true
);

-- 2. modify the policy / ONLY authenticated users can upload assets | specific bucket
create policy "policy_name"
on storage.objects for insert to authenticated with check (
    -- restrict bucket
    bucket_id = 'my_bucket_id'
);

-- 3. authenticated users can upload files | `my_bucket_id`'s `private` folder
create policy "Allow authenticated uploads"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'my_bucket_id' and
  (storage.foldername(name))[1] = 'private'
);

-- 4. authenticated users can upload files | `my_bucket_id`'s `users.id` folder
create policy "Allow authenticated uploads"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'my_bucket_id' and
  (storage.foldername(name))[1] = (select auth.jwt()->>'sub')
);

-- 5. user can access a file / PREVIOUSLY uploaded by the SAME user
create policy "Individual user Access"
on storage.objects for select
to authenticated
using ( (select auth.jwt()->>'sub') = owner_id );

-- 6. ANYONE can access -- , via publishable key, -- `avatars` bucket's objects
create policy "Avatar images are publicly accessible." on storage.objects
    for select using (bucket_id = 'avatars' and storage.allow_any_operation(array['object.get_authenticated_info', 'object.get_authenticated']));
