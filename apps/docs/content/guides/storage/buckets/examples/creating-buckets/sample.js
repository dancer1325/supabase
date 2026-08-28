import { createClient } from '@supabase/supabase-js'
const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_KEY!)

// ---cut---
// Use the JS library to create a bucket.

const { data, error } = await supabase.storage.createBucket('avatars', {
    public: true, // default: false
    // restriction uploads
    allowedMimeTypes: ['image/*'],
    fileSizeLimit: '1MB',
})