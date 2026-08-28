void main() async {
  final supabase = SupabaseClient('supabaseUrl', 'supabaseKey');

  final storageResponse = await supabase
      .storage
      .createBucket('avatars');
}