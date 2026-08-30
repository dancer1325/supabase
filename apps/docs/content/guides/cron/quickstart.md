---
title: 'Quickstart'
---

* Job names
  * case sensitive
  * ❌ONCE created, they can NOT be edited❌
  * if you try to create a 2@ Job / SAME name -> overwrite the first Job

## Schedule a job

* ways
  * -- via -- Supabase Dashboard > Integrations > Crob > Jobs > Create job
    * name
    * choose cron expression OR natural language
    * choose type
      * SQL snippet
      * Database function
      * HTTP request
      * Supabase Edge Function
  * -- via -- SQL

* cron syntax

  ```
  ┌───────────── min (0 - 59)
  │ ┌────────────── hour (0 - 23)
  │ │ ┌─────────────── day of month (1 - 31)
  │ │ │ ┌──────────────── month (1 - 12)
  │ │ │ │ ┌───────────────── day of week (0 - 6) (0 to 6 are Sunday to
  │ │ │ │ │                  Saturday, or use names; 7 is also Sunday)
  │ │ │ │ │
  │ │ │ │ │
  * * * * *
  ```

  * | Postgres v15.1.1.61+,
    * you can input seconds

## Edit a job

* ways
  * -- via -- Supabase Dashboard > Integrations > Crob > Jobs > Choose the job > "Edit cron job"
  * -- via -- SQL
    * `cron.alter_job()`, OR

      ```sql
      cron.alter_job(
        job_id bigint,
        schedule text default null,
        command text default null,
        database text default null,
        username text default null,
        active boolean default null
      )
      ```

    * `cron.schedule()`

## Activate/Deactivate a job

TODO: 

<Tabs
  scrollable
  size="small"
  type="underlined"
  defaultActiveId="dashboard-unschedule-job"
  queryGroup="database-method"
>
<TabPanel id="dashboard-unschedule-job" label="Dashboard">

1. Go to the [Jobs](/dashboard/project/_/integrations/cron/jobs) section and find the Job you'd like to unschedule.
2. Toggle the `Active`/`Inactive` switch next to Job name.

</TabPanel>
<TabPanel id="sql-unschedule-job" label="SQL">

```sql
-- Activate Job
select cron.alter_job(
  job_id := (select jobid from cron.job where jobname = 'permanent-cron-job-name'),
  active := true
);

-- Deactivate Job
select cron.alter_job(
  job_id := (select jobid from cron.job where jobname = 'permanent-cron-job-name'),
  active := false
);
```

</TabPanel>
</Tabs>

## Unschedule a job

<Tabs
  scrollable
  size="small"
  type="underlined"
  defaultActiveId="dashboard-delete-job"
  queryGroup="database-method"
>
<TabPanel id="dashboard-delete-job" label="Dashboard">

1. Go to the [Jobs](/dashboard/project/_/integrations/cron/jobs) section and find the Job you'd like to delete.
2. Click on the three vertical dots menu on the right side of the Job and click `Delete cron job`.
3. Confirm deletion by entering the Job name.

</TabPanel>
<TabPanel id="sql-delete-job" label="SQL">

```sql
select cron.unschedule('permanent-cron-job-name');
```

<Admonition type="caution">

Unscheduling a Job will permanently delete the Job from `cron.job` table but its run history remain in `cron.job_run_details` table.

</Admonition>

</TabPanel>
</Tabs>

## Inspecting job runs

<Tabs
  scrollable
  size="small"
  type="underlined"
  defaultActiveId="dashboard-runs-job"
  queryGroup="database-method"
>
<TabPanel id="dashboard-runs-job" label="Dashboard">

1. Go to the [Jobs](/dashboard/project/_/integrations/cron/jobs) section and find the Job you want to see the runs of.
2. Click on the `History` button next to the Job name.

</TabPanel>
<TabPanel id="sql-runs-job" label="SQL">

```sql
select
  *
from cron.job_run_details
where jobid = (select jobid from cron.job where jobname = 'permanent-cron-job-name')
order by start_time desc
limit 10;
```

<Admonition type="caution">

The records in the `cron.job_run_details` table are not cleaned up automatically
* They are also not removed when jobs are unscheduled, which will take up disk space in your database.

</Admonition>

</TabPanel>
</Tabs>

## Examples

### Delete data every week

{/* <!-- vale off --> */}

Delete old data every Saturday at 3:30AM (GMT):

{/* <!-- vale on --> */}

```sql
select cron.schedule (
  'saturday-cleanup', -- name of the cron job
  '30 3 * * 6', -- Saturday at 3:30AM (GMT)
  $$ delete from events where event_time < now() - interval '1 week' $$
);
```

### Run a vacuum every day

{/* <!-- vale off --> */}

Vacuum every day at 3:00AM (GMT):

{/* <!-- vale on --> */}

```sql
select cron.schedule('nightly-vacuum', '0 3 * * *', 'VACUUM');
```

### Call a database function every 5 minutes

Create a [`hello_world()`](/docs/guides/database/functions?language=sql#simple-functions) database function and then call it every 5 minutes:

```sql
select cron.schedule('call-db-function', '*/5 * * * *', 'SELECT hello_world()');
```

### Call a database stored procedure

To use a stored procedure, you can call it like this:

```sql
select cron.schedule('call-db-procedure', '*/5 * * * *', 'CALL my_procedure()');
```

### Invoke Supabase Edge Function every 30 seconds

Make a POST request to a Supabase Edge Function every 30 seconds:

```sql
select
  cron.schedule(
    'invoke-function-every-half-minute',
    '30 seconds',
    $$
    select
      net.http_post(
          url:='https://project-ref.supabase.co/functions/v1/function-name',
          headers:=jsonb_build_object('Content-Type','application/json', 'apikey', 'YOUR_PUBLISHABLE_KEY'),
          body:=jsonb_build_object('time', now() ),
          timeout_milliseconds:=5000
      ) as request_id;
    $$
  );
```

<Admonition type="note">

This requires the [`pg_net` extension](/docs/guides/database/extensions/pg_net) to be enabled.

</Admonition>

## Caution: Scheduling system maintenance

Be extremely careful when setting up Jobs for system maintenance tasks as they can have unintended consequences.

For instance, scheduling a command to terminate idle connections with `pg_terminate_backend(pid)` can disrupt critical background processes like nightly backups
* Often, there is an existing Postgres setting, such as `idle_session_timeout`, that can perform these common maintenance tasks without the risk.

Reach out to [Supabase Support](/support) if you're unsure if that applies to your use case.
