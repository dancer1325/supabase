# Diffing changes
* steps
  * Supabase Dashboard > Table Editor > create a new table: "cities" / columns: `id`, `name` and `population`
  * `supabase db diff -f create_cities_table`
  * `supabase db reset`
