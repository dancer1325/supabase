final res = await supabase.auth.signUp(
  email: 'valid.email@supabase.io',
  password: 'example-password',
  data: {
    'first_name': 'John',
    'age': 27,
  },
);

final User? user = supabase.auth.currentUser;
final Map<String, dynamic>? metadata = user?.userMetadata;