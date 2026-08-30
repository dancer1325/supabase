# how has it been created?
* `mkdir sample`
* | sample,
  * `supabase init`
  * `supabase functions new resend`
  * edit "supabase/functions/resend/index.tsx"
  * `cp .env.template .env`
  * configure ".env"
  * `supabase functions serve --no-verify-jwt --env-file .env`
  * Supabase Dashboard > project > choose the project > functions > secrets > configure `RESEND_API_KEY`
  * `supabase start`
  * `supabase functions deploy resend --no-verify-jwt`
