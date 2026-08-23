// 1. execute basic function
final data = await supabase.rpc('hello_world');

// 2. apply filter & selectors
final data = await supabase
  .rpc('get_planets')
  .eq('id', 1);

// 3. passing parameters
final data = await supabase
  .rpc('add_planet', params: { 'name': 'Jakku' });