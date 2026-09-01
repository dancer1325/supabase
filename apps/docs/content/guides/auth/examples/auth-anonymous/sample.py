#  1. Sign in anonymously
response = supabase.auth.sign_in_anonymously()


# 2. Link email identity to anonymous user
response = supabase.auth.update_user({
  'email': 'valid.email@supabase.io',
})

# verify the user's email by clicking on the email change link
# or entering the 6-digit OTP sent to the email address

# once the user has been verified, update the password
response = supabase.auth.update_user({
  'password': 'password',
})

# 3. Link OAuth identity to anonymous user
response = supabase.auth.link_identity({'provider': 'google'})