# 1. create a bucket
response = supabase.storage.create_bucket('avatars')

# 3. download a file.
response = supabase.storage.from_('avatars').download('public/avatar1.png')