select cron.alter_job(
               job_id := (select jobid from cron.job where jobname = 'permanent-cron-job-name'),
               schedule := '*/5 * * * *'
       );