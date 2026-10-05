# 1. sign in -- with -- phone OTP
response = supabase.auth.sign_in_with_otp({
  'phone': '+13334445555',
})

# 2. verify a phone OTP
response = supabase.auth.verify_otp({
  'phone': '13334445555',
  'token': '123456',
  'type': 'sms',
})

# 3. update a phone number
response = supabase.auth.update_user({
  'phone': '123456789',
})