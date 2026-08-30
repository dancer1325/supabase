---
title: 'Install'
---

* ways to install
  * -- via -- Supabase Dashboard > Integrations -> Cron > click enable
  * -- via -- SQL

    ```sql
    create extension pg_cron with schema pg_catalog;
    
    grant usage on schema cron to postgres;
    grant all privileges on all tables in schema cron to postgres;
    ```

## Uninstall

* == disable `pg_cron` extension
  * -> delete ALL jobs

* ways to uninstall
  * -- via -- Supabase Dashboard > Integrations -> Cron > click disable
  * -- via -- SQL 

    ```sql
    drop extension if exists pg_cron;
    ```
