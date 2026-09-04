-- 1. create a table | store jobs
create table job_queue (
                           job_id uuid primary key default gen_random_uuid(),
                           job_data jsonb not null,
                           created_at timestamp default now(),
                           status text default 'pending',
                           priority int default 0,
                           retry_count int default 0,
                           max_retries int default 2,
                           scheduled_at timestamp default now()
);

-- 2. create the hook
create or replace function send_email(event jsonb) returns jsonb as $$
declare
job_data jsonb;
    scheduled_time timestamp;
    priority int;
begin
    -- Extract email details from the event JSON
    job_data := jsonb_build_object(
        'email_action_type', event->'email_data'->>'email_action_type',
        'token_hash', event->'email_data'->>'token_hash',
        'token', event->'email_data'->>'token',
        'email', event->'user'->>'email'
    );

    -- Calculate the nearest 5-minute window for scheduled_time
    scheduled_time := date_trunc('minute', now()) + interval '5 minute' * floor(extract('epoch' from (now() - date_trunc('minute', now())) / 60) / 5);

    -- Assign priority dynamically (example logic: higher priority for earlier scheduled time)
    priority := extract('epoch' from (scheduled_time - now()))::int;

insert into public.job_queue (job_data, priority, scheduled_at, max_retries)
values (job_data, priority, scheduled_time, 2);

return '{}'::jsonb;
end;
$$ language plpgsql;

grant all
on table public.job_queue
  to supabase_auth_admin;

revoke all
    on table public.job_queue
    from authenticated, anon;

-- 3. create a function / periodically run & dequeue ALL jobs
create or replace function dequeue_and_run_jobs() returns void as $$
declare
job record;
begin
for job in
select * from job_queue
where status = 'pending'
  and scheduled_at <= now()
order by priority desc, created_at
    for update skip locked
    loop
begin
            -- add job processing logic here.
            -- for demonstration, we'll just update the job status to 'completed'.
update job_queue
set status = 'completed'
where job_id = job.job_id;

exception when others then
            -- handle job failure and retry logic
            if job.retry_count < job.max_retries then
update job_queue
set retry_count = retry_count + 1,
    scheduled_at = now() + interval '1 minute'  -- delay retry by 1 minute
where job_id = job.job_id;
else
update job_queue
set status = 'failed'
where job_id = job.job_id;
end if;
end;
end loop;
end;
$$ language plpgsql;

grant execute
    on function public.dequeue_and_run_jobs
    to supabase_auth_admin;

revoke execute
    on function public.dequeue_and_run_jobs
    from authenticated, anon;

select
    cron.schedule(
            '* * * * *', -- this cron expression means every minute.
            'select dequeue_and_run_jobs();'
    );
