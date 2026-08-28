--  goal: create INSER RLS policy / restrict them -- to -- meet your security requirements

create policy "policy_name"
ON storage.objects
for insert with check (
  true
);

-- modify the policy / ONLY authenticated users can upload assets | specific bucket
create policy "policy_name"
on storage.objects for insert to authenticated with check (
    -- restrict bucket
    bucket_id = 'my_bucket_id'
);