---
id: 'local-development-testing-pgtap-extended'
title: 'Advanced pgTAP Testing'
description: 'Learn how to leverage dbdev and test helpers for advanced database testing.'
---

* pgTAP
  * provides
    * excellent testing capabilities 
  * allows
    * enhance -- , via database development tools & helper packages, -- the testing workflow 

* goal
  * advanced testing techniques -- via --
    * database.dev
    * community-maintained test helpers

## Using [database.dev](https://database.dev)

* Database.dev
  * == package manager for Postgres /
    * allows , about community-maintained packages, 
      * installation
      * use of
  * steps
    * set up dbdev
    * install test helpers

* Test Helpers package
  * provides
    * utilities / simplify testing Supabase-specific features

## Test helper benefits

* test helpers package's benefits vs raw pgTAP tests
  1. **Simplified User Management**
     * `tests.create_supabase_user()`
       * == create test users 
     * `tests.authenticate_as()`
       * == switch contexts 
     * `tests.get_supabase_uid()`
       * retrieve user IDs 
  2. **Row Level Security (RLS) Testing Utilities**
     * `tests.rls_enabled()`
       * == verify RLS status 
     * Test policy enforcement
     * Simulate DIFFERENT user contexts
  3. **Reduced Boilerplate**
     * NO need to MANUALLY insert auth.users
     * Simplified JWT claim management
     * Clean test setup and cleanup

## Schema-wide RLS testing

* enable RLS | ALL tables / need it

## Test file organization

* 1! "pre-test" file / handles the GLOBAL environment setup
  * use case
    * work with >1 test files / share COMMON setup requirements  
  * allows
    * reduces duplication
    * consistent test environments

### Creating a pre-test hook

* pre-test hook
  * == pgTAP test file /
    * naming recommendation: "00*.sql"
      * Reason:🧠are executed -- via -- alphabetical order🧠
      * _Example:_ "000-setup-tests-hooks.sql"
    * contain
      * ALL shared extensions & dependencies
      * COMMON test utilities
      * basic ALWAYS-green test / verify the setup 

### Benefits

TODO: 
This approach provides several advantages:

- Reduces code duplication across test files
- Ensures consistent test environment setup
- Makes it easier to maintain and update shared dependencies
- Provides immediate feedback if the setup process fails

Your subsequent test files (`001-auth-tests.sql`, `002-rls-tests.sql`) can focus solely
on their specific test cases, knowing that the environment is properly configured.

## Not another todo app: Testing complex organizations

Todo apps are great for learning, but this section explores testing a more realistic scenario: 
a multi-tenant content publishing platform
* This example demonstrates testing complex permissions, plan restrictions, and content management.

### System overview

This demo app implements:

- Organizations with tiered plans (free/pro/enterprise)
- Role-based access (owner/admin/editor/viewer)
- Content management (posts/comments)
- Premium content restrictions
- Plan-based limitations

### What makes this complex?

1. **Layered Permissions**
   - Role hierarchies affect access rights
   - Plan types influence user capabilities
   - Content state (draft/published) affects permissions

2. **Business Rules**
   - Free plan post limits
   - Premium content visibility
   - Cross-organization security

### Testing focus areas

When writing tests, verify:

- Organization member access control
- Content visibility across roles
- Plan limitation enforcement
- Cross-organization data isolation

#### 1. App schema definitions

The app schema tables are defined like this:

```sql
create table public.profiles (
  id uuid references auth.users(id) primary key,
  username text unique not null,
  full_name text,
  bio text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table public.organizations (
  id bigint primary key generated always as identity,
  name text not null,
  slug text unique not null,
  plan_type text not null check (plan_type in ('free', 'pro', 'enterprise')),
  max_posts int not null default 5,
  created_at timestamptz default now()
);

create table public.org_members (
  org_id bigint references public.organizations(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  role text not null check (role in ('owner', 'admin', 'editor', 'viewer')),
  created_at timestamptz default now(),
  primary key (org_id, user_id)
);

create table public.posts (
  id bigint primary key generated always as identity,
  title text not null,
  content text not null,
  author_id uuid references public.profiles(id) not null,
  org_id bigint references public.organizations(id),
  status text not null check (status in ('draft', 'published', 'archived')),
  is_premium boolean default false,
  scheduled_for timestamptz,
  category text,
  view_count int default 0,
  published_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table public.comments (
  id bigint primary key generated always as identity,
  post_id bigint references public.posts(id) on delete cascade,
  author_id uuid references public.profiles(id),
  content text not null,
  is_deleted boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
```

#### 2. Grant role privileges

Grant the necessary privileges for each role, ensuring the principle of least privilege is followed:

```sql
-- Grant the privileges that roles need
GRANT SELECT ON public.profiles TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO service_role;

GRANT SELECT ON public.organizations TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.organizations TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.organizations TO service_role;

GRANT SELECT ON public.org_members TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.org_members TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.org_members TO service_role;

GRANT SELECT ON public.posts TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.posts TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.posts TO service_role;

GRANT SELECT ON public.comments TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.comments TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.comments TO service_role;
```

#### 3. RLS policies declaration

Now to setup the RLS policies for each tables:

```sql
-- Create a private schema to store all security definer functions utils
-- As such functions should never be in an API exposed schema
create schema if not exists private;
-- Helper function for role checks
create or replace function private.get_user_org_role(org_id bigint, user_id uuid)
returns text
set search_path = ''
as $$
  select role from public.org_members
  where org_id = $1 and user_id = $2;
-- Note the use of security definer to avoid RLS checking recursion issue
-- see: https://supabase.com/docs/guides/database/postgres/row-level-security#use-security-definer-functions
$$ language sql security definer;
-- Helper utils to check if an org is below the max post limit
create or replace function private.can_add_post(org_id bigint)
returns boolean
set search_path = ''
as $$
  select (select count(*)
          from public.posts p
          where p.org_id = $1) < o.max_posts
  from public.organizations o
  where o.id = $1
$$ language sql security definer;


-- Enable RLS for all tables
alter table public.profiles enable row level security;
alter table public.organizations enable row level security;
alter table public.org_members enable row level security;
alter table public.posts enable row level security;
alter table public.comments enable row level security;

-- Profiles policies
create policy "Public profiles are viewable by everyone"
  on public.profiles for select using (true);

create policy "Users can insert their own profile"
  on public.profiles for insert with check ((select auth.uid()) = id);

create policy "Users can update their own profile"
  on public.profiles for update using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

-- Organizations policies
create policy "Public org info visible to all"
  on public.organizations for select using (true);

create policy "Org management restricted to owners"
  on public.organizations for all using (
    private.get_user_org_role(id, (select auth.uid())) = 'owner'
  );

-- Org Members policies
create policy "Members visible to org members"
  on public.org_members for select using (
    private.get_user_org_role(org_id, (select auth.uid())) is not null
  );

create policy "Member management restricted to admins and owners"
  on public.org_members for all using (
    private.get_user_org_role(org_id, (select auth.uid())) in ('owner', 'admin')
  );

-- Posts policies
create policy "Complex post visibility"
  on public.posts for select using (
    -- Published non-premium posts are visible to all
    (status = 'published' and not is_premium)
    or
    -- Premium posts visible to org members only
    (status = 'published' and is_premium and
    private.get_user_org_role(org_id, (select auth.uid())) is not null)
    or
    -- All posts visible to editors and above
    private.get_user_org_role(org_id, (select auth.uid())) in ('owner', 'admin', 'editor')
  );

create policy "Post creation rules"
  on public.posts for insert with check (
    -- Must be org member with appropriate role
    private.get_user_org_role(org_id, (select auth.uid())) in ('owner', 'admin', 'editor')
    and
    -- Check org post limits for free plans
    (
      (select o.plan_type != 'free'
      from organizations o
      where o.id = org_id)
      or
      (select private.can_add_post(org_id))
    )
  );

create policy "Post update rules"
  on public.posts for update using (
    exists (
      select 1
      where
        -- Editors can update non-published posts
        (private.get_user_org_role(org_id, (select auth.uid())) = 'editor' and status != 'published')
        or
        -- Admins and owners can update any post
        private.get_user_org_role(org_id, (select auth.uid())) in ('owner', 'admin')
    )
  );

-- Comments policies
create policy "Comments on published posts are viewable by everyone"
  on public.comments for select using (
    exists (
      select 1 from public.posts
      where id = post_id
      and status = 'published'
    )
    and not is_deleted
  );

create policy "Authenticated users can create comments"
  on public.comments for insert with check ((select auth.uid()) = author_id);

create policy "Users can update their own comments"
  on public.comments for update using (author_id = (select auth.uid()));
```

#### 4. Test cases:

With setup complete, write RLS test cases
* Each section can be in its own test:

```sql
-- Assuming we already have: 000-setup-tests-hooks.sql file we can use tests helpers
begin;
-- Declare total number of tests
select plan(10);

-- Create test users
select tests.create_supabase_user('org_owner', 'owner@test.com');
select tests.create_supabase_user('org_admin', 'admin@test.com');
select tests.create_supabase_user('org_editor', 'editor@test.com');
select tests.create_supabase_user('premium_user', 'premium@test.com');
select tests.create_supabase_user('free_user', 'free@test.com');
select tests.create_supabase_user('scheduler', 'scheduler@test.com');
select tests.create_supabase_user('free_author', 'free_author@test.com');

-- Create profiles for test users
insert into profiles (id, username, full_name)
values
  (tests.get_supabase_uid('org_owner'), 'org_owner', 'Organization Owner'),
  (tests.get_supabase_uid('org_admin'), 'org_admin', 'Organization Admin'),
  (tests.get_supabase_uid('org_editor'), 'org_editor', 'Organization Editor'),
  (tests.get_supabase_uid('premium_user'), 'premium_user', 'Premium User'),
  (tests.get_supabase_uid('free_user'), 'free_user', 'Free User'),
  (tests.get_supabase_uid('scheduler'), 'scheduler', 'Scheduler User'),
  (tests.get_supabase_uid('free_author'), 'free_author', 'Free Author');

-- First authenticate as service role to bypass RLS for initial setup
select tests.authenticate_as_service_role();

-- Create test organizations and setup data
with new_org as (
  insert into organizations (name, slug, plan_type, max_posts)
  values
    ('Test Org', 'test-org', 'pro', 100),
    ('Premium Org', 'premium-org', 'enterprise', 1000),
    ('Schedule Org', 'schedule-org', 'pro', 100),
    ('Free Org', 'free-org', 'free', 2)
  returning id, slug
),
-- Setup members and posts
member_setup as (
  insert into org_members (org_id, user_id, role)
  select
    org.id,
    user_id,
    role
  from new_org org cross join (
    values
      (tests.get_supabase_uid('org_owner'), 'owner'),
      (tests.get_supabase_uid('org_admin'), 'admin'),
      (tests.get_supabase_uid('org_editor'), 'editor'),
      (tests.get_supabase_uid('premium_user'), 'viewer'),
      (tests.get_supabase_uid('scheduler'), 'editor'),
      (tests.get_supabase_uid('free_author'), 'editor')
  ) as members(user_id, role)
  where org.slug = 'test-org'
     or (org.slug = 'premium-org' and role = 'viewer')
     or (org.slug = 'schedule-org' and role = 'editor')
     or (org.slug = 'free-org' and role = 'editor')
)
-- Setup initial posts
insert into posts (title, content, org_id, author_id, status, is_premium, scheduled_for)
select
  title,
  content,
  org.id,
  author_id,
  status,
  is_premium,
  scheduled_for
from new_org org cross join (
  values
    ('Premium Post', 'Premium content', tests.get_supabase_uid('premium_user'), 'published', true, null),
    ('Free Post', 'Free content', tests.get_supabase_uid('premium_user'), 'published', false, null),
    ('Future Post', 'Future content', tests.get_supabase_uid('scheduler'), 'published', false, '2024-01-02 12:00:00+00'::timestamptz)
) as posts(title, content, author_id, status, is_premium, scheduled_for)
where org.slug in ('premium-org', 'schedule-org');

-- Test owner privileges
select tests.authenticate_as('org_owner');
select lives_ok(
  $$
    update organizations
    set name = 'Updated Org'
    where id = (select id from organizations limit 1)
  $$,
  'Owner can update organization'
);

-- Test admin privileges
select tests.authenticate_as('org_admin');
select results_eq(
    $$select count(*) from org_members$$,
    ARRAY[6::bigint],
    'Admin can view all members'
);

-- Test editor restrictions
select tests.authenticate_as('org_editor');
select throws_ok(
  $$
    insert into org_members (org_id, user_id, role)
    values (
      (select id from organizations limit 1),
      (select tests.get_supabase_uid('org_editor')),
      'viewer'
    )
  $$,
  '42501',
  'new row violates row-level security policy for table "org_members"',
  'Editor cannot manage members'
);

-- Premium Content Access Tests
select tests.authenticate_as('premium_user');
select results_eq(
    $$select count(*) from posts where org_id = (select id from organizations where slug = 'premium-org')$$,
    ARRAY[3::bigint],
    'Premium user can see all posts'
);

select tests.clear_authentication();
select results_eq(
    $$select count(*) from posts where org_id = (select id from organizations where slug = 'premium-org')$$,
    ARRAY[2::bigint],
    'Anonymous users can only see free posts'
);

-- Time-Based Publishing Tests
select tests.authenticate_as('scheduler');
select tests.freeze_time('2024-01-01 12:00:00+00'::timestamptz);

select results_eq(
    $$select count(*) from posts where scheduled_for > now() and org_id = (select id from organizations where slug = 'schedule-org')$$,
    ARRAY[1::bigint],
    'Can see scheduled posts'
);

select tests.freeze_time('2024-01-02 13:00:00+00'::timestamptz);

select results_eq(
    $$select count(*) from posts where scheduled_for < now() and org_id = (select id from organizations where slug = 'schedule-org')$$,
    ARRAY[1::bigint],
    'Can see posts after schedule time'
);

select tests.unfreeze_time();

-- Plan Limit Tests
select tests.authenticate_as('free_author');

select lives_ok(
  $$
    insert into posts (title, content, org_id, author_id, status)
    select 'Post 1', 'Content 1', id, auth.uid(), 'draft'
    from organizations where slug = 'free-org' limit 1
  $$,
  'First post creates successfully'
);

select lives_ok(
  $$
    insert into posts (title, content, org_id, author_id, status)
    select 'Post 2', 'Content 2', id, auth.uid(), 'draft'
    from organizations where slug = 'free-org' limit 1
  $$,
  'Second post creates successfully'
);

select throws_ok(
  $$
    insert into posts (title, content, org_id, author_id, status)
    select 'Post 3', 'Content 3', id, auth.uid(), 'draft'
    from organizations where slug = 'free-org' limit 1
  $$,
  '42501',
  'new row violates row-level security policy for table "posts"',
  'Cannot exceed free plan post limit'
);

select * from finish();
rollback;
```

## Additional resources

* [Test Helpers Documentation](https://database.dev/basejump/supabase_test_helpers)
- [Test Helpers Reference](https://github.com/usebasejump/supabase-test-helpers)
- [Row Level Security Writing Guide](https://usebasejump.com/blog/testing-on-supabase-with-pgtap)
- [Database.dev Package Registry](https://database.dev)
- [Row Level Security Performance and Best Practices](https://github.com/orgs/supabase/discussions/14576)
