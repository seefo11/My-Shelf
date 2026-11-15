-- My Shelf update (v16): run ONCE in Supabase > SQL Editor
create or replace function delete_my_account() returns void language sql security definer set search_path=public,auth as $$ delete from auth.users where id=auth.uid() $$;
revoke all on function delete_my_account() from public, anon;
grant execute on function delete_my_account() to authenticated;
