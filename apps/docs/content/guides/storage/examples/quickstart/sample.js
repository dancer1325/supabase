// Use the JS library to create a bucket.

const { data, error } = await supabase.storage.createBucket('avatars')

// 2. upload a file
const avatarFile = event.target.files[0]
const { data, error } = await supabase.storage
    .from('avatars')
    .upload('public/avatar1.png', avatarFile)


// 3. download a file.
const { data, error } = await supabase.storage.from('avatars').download('public/avatar1.png')
