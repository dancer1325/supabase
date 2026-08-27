try await supabase.auth.signUp(
  email: "valid.email@supabase.io",
  password: "example-password",
  data: [
    "first_name": .string("John"),
    "age": .integer(27),
  ]
)

let user = try await supabase.auth.user()
let metadata = user.userMetadata