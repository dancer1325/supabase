// 1. Sign in anonymously
await supabase.auth.signInAnonymously();

// 2. Link email identity to anonymous user
await supabase.auth.updateUser(UserAttributes(email: 'valid.email@supabase.io'));

// 3. Link OAuth identity to anonymous user
await supabase.auth.linkIdentity(OAuthProvider.google);