-- My Shelf update (v19): safe to run more than once
create table if not exists vault_imgs(user_id uuid references auth.users on delete cascade, img_id text, data text, primary key(user_id,img_id));
alter table vault_imgs enable row level security;
drop policy if exists vi_all on vault_imgs;
create policy vi_all on vault_imgs for all to authenticated using (user_id=auth.uid()) with check (user_id=auth.uid());
create or replace function are_friends(a uuid,b uuid) returns bool language sql security definer stable set search_path=public as $$ select auth.uid() in (a,b) and exists(select 1 from friendships where status='accepted' and ((requester=a and addressee=b) or (requester=b and addressee=a))) $$;
create or replace function lock_friend_cols() returns trigger language plpgsql as $$ begin if new.requester<>old.requester or new.addressee<>old.addressee then raise exception 'cannot change friendship parties'; end if; return new; end $$;
drop trigger if exists lock_friend on friendships;
create trigger lock_friend before update on friendships for each row execute function lock_friend_cols();
