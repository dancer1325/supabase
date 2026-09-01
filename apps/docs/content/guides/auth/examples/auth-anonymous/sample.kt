// 1. Sign in anonymously
supabase.auth.signInAnonymously()

// 2. Link email identity to anonymous user
supabase.auth.updateUser {
    email = "valid.email@supabase.io"
}

// 3. Link OAuth identity to anonymous user
supabase.auth.linkIdentity(Google)