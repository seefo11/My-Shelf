-- My Shelf update (v12): run ONCE in Supabase > SQL Editor
alter table profiles add column if not exists photo text;
create or replace function popular_books(lim int default 20) returns table(title text, author text, cover text, pages int, fans bigint) language sql security definer stable set search_path=public as $$
 select min(sb.title), min(sb.author), min(sb.cover), max(sb.pages), count(distinct sb.owner)
 from shared_books sb join profiles p on p.id=sb.owner
 where sb.fav and coalesce((p.share->>'discover')::bool,true)
 group by lower(sb.title), lower(coalesce(sb.author,''))
 order by 5 desc, 1 limit lim $$;
grant execute on function popular_books(int) to authenticated;
