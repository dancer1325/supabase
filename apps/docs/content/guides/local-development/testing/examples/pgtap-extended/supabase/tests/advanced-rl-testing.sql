begin;
-- Assuming 000-setup-tests-hooks.sql file is present to use tests helpers
select plan(4);

-- Set up test data

-- Create test supabase users
select tests.create_supabase_user('user1@test.com');
select tests.create_supabase_user('user2@test.com');

-- Create test data
insert into public.todos (task, user_id) values
                                             ('User 1 Task 1', tests.get_supabase_uid('user1@test.com')),
                                             ('User 1 Task 2', tests.get_supabase_uid('user1@test.com')),
                                             ('User 2 Task 1', tests.get_supabase_uid('user2@test.com'));

-- Test as User 1
select tests.authenticate_as('user1@test.com');

-- Test 1: User 1 should only see their own todos
select results_eq(
               'select count(*) from todos',
               ARRAY[2::bigint],
               'User 1 should only see their 2 todos'
       );

-- Test 2: User 1 can create their own todo
select lives_ok(
               $$insert into todos (task, user_id) values ('New Task', tests.get_supabase_uid('user1@test.com'))$$,
               'User 1 can create their own todo'
       );

-- Test as User 2
select tests.authenticate_as('user2@test.com');

-- Test 3: User 2 should only see their own todos
select results_eq(
               'select count(*) from todos',
               ARRAY[1::bigint],
               'User 2 should only see their 1 todo'
       );

-- Test 4: User 2 cannot modify User 1's todo
SELECT results_ne(
               $$ update todos set task = 'Hacked!' where user_id = tests.get_supabase_uid('user1@test.com') returning 1 $$,
               $$ values(1) $$,
               'User 2 cannot modify User 1 todos'
       );

select * from finish();
rollback;