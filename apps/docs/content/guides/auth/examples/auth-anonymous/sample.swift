// 1. Sign in anonymously
let session = try await supabase.auth.signInAnonymously()

// 2. Link email identity to anonymous user
try await supabase.auth.update(
  user: UserAttributes(email: "valid.email@supabase.io")
)

// 3. Link OAuth identity to anonymous user
try await supabase.auth.linkIdentity(provider: .google)