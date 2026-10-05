// 1. sign in -- with -- phone OTP
supabase.auth.signInWith(OTP) {
    phone = "+13334445555"
}

// To send the OTP via WhatsApp instead of SMS (requires Twilio or Twilio Verify provider):
supabase.auth.signInWith(OTP) {
    phone = "+13334445555"
    channel = Phone.Channel.WHATSAPP
}

// 2. verify a phone OTP
supabase.auth.verifyPhoneOtp(
    type = OtpType.Phone.SMS,
    phone = "+13334445555",
    token = "123456"
)

// 3. update a phone number
supabase.auth.updateUser {
    phone = "123456789"
}