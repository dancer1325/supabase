val data = supabase.auth.signUpWith(Email) {
    email = "valid.email@supabase.io"
    password = "example-password"
    data = buildJsonObject {
        put("first_name", "John")
        put("age", 27)
    }
}

val user = supabase.auth.retrieveUserForCurrentSession()
//Or you can use the user from the current session:
val user = supabase.auth.currentUserOrNull()
val metadata = user?.userMetadata
