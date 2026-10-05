import { createClient } from '@supabase/supabase-js'

const supabase = createClient('https://your-project-id.supabase.co', 'sb_publishable_...')

// 1. sign in -- with -- phone OTP
const { data, error } = await supabase.auth.signInWithOtp({
    phone: '+13334445555',
})

// 2. verify a phone OTP
const {
  data: { session },
  error,
} = await supabase.auth.verifyOtp({
  phone: '13334445555',
  token: '123456',
  type: 'sms',
})

// 3. update a phone number
const { data, error } = await supabase.auth.updateUser({
  phone: '123456789',
})
