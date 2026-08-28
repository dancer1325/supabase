-- Use Postgres to create a bucket.

insert into storage.buckets
(id, name)
values
    ('avatars', 'avatars');

-- 4. create a policy
create policy "Public Access"
  on storage.objects for select
    using ( bucket_id = 'public' );