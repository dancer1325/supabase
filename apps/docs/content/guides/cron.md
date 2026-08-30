---
title: 'Cron'
subtitle: 'Schedule Recurring Jobs with Cron Syntax in Postgres'
---

* Supabase Cron
  * == Postgres Module /
    * simplifies 
      * -- , via cron syntax, -- scheduling recurring Jobs /
        * EACH job can 
          * run
            * SQL snippets OR
            * database functions
          * make an HTTP request
            * _Example:_ invoke a Supabase Edge Function
      * monitoring Job / run | Postgres
  * [how to install?](cron/install.md)
  * how does it work?
    * -- through -- [`pg_cron`](https://github.com/citusdata/pg_cron) / 
      * == Postgres database extension
      * creates a `cron` schema | your database
      * ALL Jobs 
        * are stored | `cron.job` table
        * 's run & 's status are recorded | `cron.job_run_details` table

![Manage cron jobs via the Dashboard (dark)](../../public/img/guides/cron/cron.jpg)

* recommendations
  * \<= 8 8 jobs running CONCURRENTLY
  * job's run time <= 10 minutes

## Resources

- [`pg_cron` GitHub Repository](https://github.com/citusdata/pg_cron)
