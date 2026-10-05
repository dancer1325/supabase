// 1. sign in -- with -- phone OTP
try await supabase.auth.signInWithOTP(
  phone: "+13334445555"
)

// 2. verify a phone OTP
try await supabase.auth.verifyOTP(
  phone: "+13334445555",
  token: "123456",
  type: .sms
)

// 3. update a phone number
try await supabase.auth.updateUser(
  user: UserAttributes(
    phone: "123456789"
  )
)