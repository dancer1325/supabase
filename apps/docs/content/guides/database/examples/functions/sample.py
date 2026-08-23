# 1. execute basic function
data = supabase.rpc('hello_world').execute()

# 2. apply filter & selectors
data = supabase.rpc('get_planets').eq('id', 1).execute()

# 3. passing parameters
data = supabase.rpc('add_planet', params={'name': 'Jakku'}).execute()