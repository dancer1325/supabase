// 1. execute basic function
const { data, error } = await supabase.rpc('hello_world');

// 2. apply filter & selectors
const { data, error } = supabase.rpc('get_planets').eq('id', 1);

// 3. passing parameters
const { data, error } = await supabase.rpc('add_planet', { name: 'Jakku' })