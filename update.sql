-- My Shelf update (v10): run ONCE in Supabase > SQL Editor, after schema.sql
alter table profiles add column if not exists display_name text, add column if not exists bio text, add column if not exists avatar text, add column if not exists hue int default 200, add column if not exists share jsonb default '{"reading":true,"want":true,"done":true,"hl":true,"stats":true}';
alter table shared_books add column if not exists cur int, add column if not exists fin text;
create table if not exists shared_hl(owner uuid references profiles(id) on delete cascade, hl_id text, txt text, book text, pg text, color text, note text, updated_at timestamptz default now(), primary key(owner,hl_id));
create table if not exists shared_stats(owner uuid primary key references profiles(id) on delete cascade, data jsonb, updated_at timestamptz default now());
alter table shared_hl enable row level security; alter table shared_stats enable row level security;
create policy h_sel on shared_hl for select to authenticated using (owner=auth.uid() or are_friends(owner,auth.uid()));
create policy h_ins on shared_hl for insert to authenticated with check (owner=auth.uid());
create policy h_upd on shared_hl for update to authenticated using (owner=auth.uid());
create policy h_del on shared_hl for delete to authenticated using (owner=auth.uid());
create policy t_sel on shared_stats for select to authenticated using (owner=auth.uid() or are_friends(owner,auth.uid()));
create policy t_ins on shared_stats for insert to authenticated with check (owner=auth.uid());
create policy t_upd on shared_stats for update to authenticated using (owner=auth.uid());
create policy t_del on shared_stats for delete to authenticated using (owner=auth.uid());
drop policy if exists p_sel on profiles;
create policy p_sel on profiles for select to authenticated using (true);
create or replace function username_free(u text) returns bool language sql security definer stable set search_path=public as $$ select not exists(select 1 from profiles where username=u) $$;
grant execute on function username_free(text) to anon, authenticated;
