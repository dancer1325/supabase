import { createClient } from '@supabase/supabase-js'

const supabase = createClient('https://your-project-id.supabase.co', 'sb_publishable_...')

// 1. Sign in anonymously
const { data, error } = await supabase.auth.signInAnonymously()

// 2. Link email identity to anonymous user
const { data: updateEmailData, error: updateEmailError } = await supabase.auth.updateUser({
  email: 'valid.email@supabase.io',
})

// verify the user's email by clicking on the email change link
// or entering the 6-digit OTP sent to the email address

// once the user has been verified, update the password
const { data: updatePasswordData, error: updatePasswordError } = await supabase.auth.updateUser({
  password: 'password',
})

// 3. Link OAuth identity to anonymous user
const { data, error } = await supabase.auth.linkIdentity({ provider: 'google' })