select cron.alter_job(
               job_id := (select jobid from cron.job where jobname = 'permanent-cron-job-name'),
               schedule := '*/5 * * * *'
       );

-- 2. delete data / EACH week | Saturday 03:30

select cron.schedule (
               'saturday-cleanup', -- name of the cron job
               '30 3 * * 6', -- Saturday at 3:30AM (GMT)
               $$ delete from events where event_time < now() - interval '1 week' $$
       );

-- 3. vacuum / EACH day

select cron.schedule('nightly-vacuum', '0 3 * * *', 'VACUUM');

-- 4. call a database function / EACH 5'

create function hello_world()
    returns text
    language plpgsql
security definer set search_path = ''
as $$
begin
return 'hello world';
end;
$$;

select cron.schedule('call-db-function', '*/5 * * * *', 'SELECT hello_world()');

-- 5. call a database stored procedure

-- 5.1  use a stored procedure
select cron.schedule('call-db-procedure', '*/5 * * * *', 'CALL my_procedure()');

-- 6. invoke Supabase Edge Function / EACH 30"
--      invoke == make a POST request
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

-- 7. activate / deactive a job

-- 7.1 Activate Job
select cron.alter_job(
       job_id := (select jobid from cron.job where jobname = 'permanent-cron-job-name'),
       active := true
);

-- 7.2 Deactivate Job
select cron.alter_job(
       job_id := (select jobid from cron.job where jobname = 'permanent-cron-job-name'),
       active := false
);

-- 8. delete a job

select cron.unschedule('permanent-cron-job-name');

-- 9. job's history

select *
from cron.job_run_details
where jobid = (select jobid from cron.job where jobname = 'permanent-cron-job-name')
order by start_time desc
    limit 10;



