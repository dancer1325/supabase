void main() async {
  final supabase = SupabaseClient('supabaseUrl', 'supabaseKey');

// 1. create a bucket
  final storageResponse = await supabase
      .storage
      .createBucket('avatars');

// 2. upload a file
final file = File('example.txt');
  file.writeAsStringSync('File content');
  final storageResponse = await supabase
      .storage
      .from('public')
      .upload('example.txt', file);

// 3. download a file
final storageResponse = await supabase
   .storage
   .from('public')
   .download('example.txt');

}


