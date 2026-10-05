-- 1. create a webhook | SQL
create trigger "my_webhook" after insert
    on "public"."my_table" for each row
    execute function "supabase_functions"."http_request"(
  'http://host.docker.internal:3000',
  'POST',
  '{"Content-Type":"application/json"}',
  '{}',
  '1000'
);