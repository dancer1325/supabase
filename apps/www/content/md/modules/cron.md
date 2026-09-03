# Supabase Cron

* [here](../../../../docs/content/guides/cron.md)

## Key Features

TODO:

- **Postgres native**: schedule and run jobs directly within your database, no external scheduler needed
- **Sub-minute scheduling**: run jobs as frequently as every 1-59 seconds
- **Real-time monitoring**: track and debug scheduled jobs with built-in observability tools
- **Extensible**: trigger database functions, Supabase Edge Functions, or HTTP webhooks
- **Dashboard management**: create, edit, and monitor jobs through an intuitive UI
- **SQL-based**: manage jobs using simple SQL commands, track changes with Postgres migrations
- **100% open source**: built on pg_cron, a trusted community-driven extension

## Common Use Cases

- Periodic data cleanup or archival
- Scheduled report generation
- Recurring API calls or webhook triggers
- Database maintenance tasks (vacuum, reindex)
- Timed cache invalidation
- Periodic data synchronization between systems

## Technical Details

- Minimum interval: 1 second
- Schedule format: cron syntax (minute/hour/day/month/weekday) or natural language
- Job targets: SQL statements, database functions, Edge Functions, HTTP endpoints
- Monitoring: job run history with status, duration, and error details
