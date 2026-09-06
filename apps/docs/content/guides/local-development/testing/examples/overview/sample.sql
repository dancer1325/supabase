-- Create a todos table
create table todos (
                       id uuid primary key default gen_random_uuid(),
                       task text not null,
                       user_id uuid references auth.users not null,
                       completed boolean default false
);

-- Enable RLS
alter table todos enable row level security;

-- Create a policy
create policy "Users can only access their own todos"
   on todos for all -- this policy applies to all operations
   to authenticated
   using ((select auth.uid()) = user_id);