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

* ways
  * -- via -- Supabase Dashboard
    * \> project > choose a project > integrations > cron > job > choose the job > activate / deactivate
  * -- via -- SQL

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

## Delete a job

* ways
  * Supabase Dashboard >  
    * \> project > choose a project > integrations > cron > jobs > choose a job > delete
  * -- via -- SQL

    ```sql
    select cron.unschedule('permanent-cron-job-name');
    ```

* job's run history
  * EXIST | `cron.job_run_details` table

## Inspecting job runs (== job's history)

* ways
  * Supabase Dashboard >
    * \> project > choose a project > integrations > cron > jobs > click | job
  * -- via -- SQL

    ```sql
    select *
    from cron.job_run_details
    where jobid = (select jobid from cron.job where jobname = 'permanent-cron-job-name')
    order by start_time desc
    limit 10;
    ```

* `cron.job_run_details` table's records
  * are NOT 
    * cleaned up AUTOMATICALLY
    * removed | unschedule jobs 
  * take up disk space | your database

## Caution: Scheduling system maintenance

* cons
  * ❌unintended consequences❌

TODO: 
For instance, scheduling a command to terminate idle connections with
`pg_terminate_backend(pid)` can disrupt critical background processes like
nightly backups
* Often, there is an existing Postgres setting, such as `idle_session_timeout`, 
that can perform these common maintenance tasks without the risk.
