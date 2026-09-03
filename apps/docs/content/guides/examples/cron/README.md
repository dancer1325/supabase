# Supabase Cron == Postgres Module
TODO:
## simplifies -- , via cron syntax, -- scheduling recurring Jobs
TODO:
### EACH job can run SQL snippets OR database functions
TODO:
### EACH job can make an HTTP request
TODO:
#### _Example:_ invoke a Supabase Edge Function
TODO:
## simplifies monitoring Job / run | Postgres
TODO:
## how does it work? -- through -- `pg_cron`
TODO:
### == Postgres database extension
TODO:
### creates a `cron` schema | your database
TODO:
### ALL Jobs are stored | `cron.job` table
TODO:
### job's run & status are recorded | `cron.job_run_details` table
TODO:
# recommendations
TODO:
## <= 8 jobs running CONCURRENTLY
TODO:
## job's run time <= 10 minutes
TODO:
