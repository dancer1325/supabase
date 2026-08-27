create table public.profiles (
                                 id uuid not null references auth.users on delete cascade,
                                 first_name text,
                                 last_name text,

                                 primary key (id)
);

-- Grant the privileges the roles need
GRANT SELECT ON public.profiles TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO service_role;

-- Enable row level security for the table
alter table public.profiles enable row level security;

-- inserts a row into public.profiles
create function public.handle_new_user()
    returns trigger
    language plpgsql
security definer set search_path = ''
as $$
begin
insert into public.profiles (id, first_name, last_name)
values (new.id, new.raw_user_meta_data ->> 'first_name', new.raw_user_meta_data ->> 'last_name');
return new;
end;
$$;

-- trigger the function every time a user is created
create trigger on_auth_user_created
    after insert on auth.users
    for each row execute procedure public.handle_new_user();

-- 3. Adding & retrieving user metadata
SELECT raw_user_meta_data FROM auth.users;