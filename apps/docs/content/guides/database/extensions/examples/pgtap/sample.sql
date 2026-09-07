-- 1. Enable the "pgtap" extension
create extension pgtap with schema extensions;


-- 2. testing the tables
begin;
select plan( 1 );

select has_table( 'profiles' );

select * from finish();
rollback;

-- 3. testing columns
begin;
select plan( 2 );

select has_column( 'profiles', 'id' ); -- test that the "id" column exists in the "profiles" table
select col_is_pk( 'profiles', 'id' ); -- test that the "id" column is a primary key

select * from finish();
rollback;

-- 4. testing RLS policies
begin;
select plan( 1 );

select policies_are(
               'public',
               'profiles',
               ARRAY [
                   'Profiles are public', -- Test that there is a policy called  "Profiles are public" on the "profiles" table.
               'Profiles can only be updated by the owner'  -- Test that there is a policy called  "Profiles can only be updated by the owner" on the "profiles" table.
                   ]
       );

select * from finish();
rollback;

begin;
select plan( 1 );

select results_eq(
               'select * from profiles()',
               $$VALUES ( 1, 'Anna'), (2, 'Bruce'), (3, 'Caryn')$$,
               'profiles() should return all users'
       );


select * from finish();
rollback;

-- 5. testing functions
prepare hello_expr as select 'hello'

begin;
select plan(3);
-- You'll need to create a hello_world and is_even function
select function_returns( 'hello_world', 'text' );                   -- test if the function "hello_world" returns text
select function_returns( 'is_even', ARRAY['integer'], 'boolean' );  -- test if the function "is_even" returns a boolean
select results_eq('select * from hello_world()', 'hello_expr');          -- test if the function "hello_world" returns "hello"

select * from finish();
rollback;

-- 6. Disable the "pgtap" extension
drop extension if exists pgtap;