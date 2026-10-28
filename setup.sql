-- Im Supabase SQL Editor einmal ausführen.
-- Vorher die beiden persönlichen Benutzer über Authentication > Users anlegen.
create table if not exists public.archive_members (
 user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.archive_members enable row level security;
create policy "members can read own membership" on public.archive_members for select to authenticated using (user_id=(select auth.uid()));
-- Die UUIDs beider Nutzer manuell in archive_members eintragen.
create table if not exists public.memories (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id),
 title text not null check (length(title) between 1 and 120),
 category text not null check(category in ('Augenblicke','Zwischen den Zeilen','Meilensteine','Nur für dich')),
 body text not null default '',
 file_path text,
 created_at timestamptz not null default now()
);
alter table public.memories enable row level security;
create policy "members read memories" on public.memories for select to authenticated using (exists(select 1 from public.archive_members m where m.user_id=(select auth.uid())));
create policy "members create memories" on public.memories for insert to authenticated with check (user_id=(select auth.uid()) and exists(select 1 from public.archive_members m where m.user_id=(select auth.uid())));
create policy "authors update memories" on public.memories for update to authenticated using(user_id=(select auth.uid()) and exists(select 1 from public.archive_members m where m.user_id=(select auth.uid()))) with check(user_id=(select auth.uid()));
create policy "authors delete memories" on public.memories for delete to authenticated using(user_id=(select auth.uid()) and exists(select 1 from public.archive_members m where m.user_id=(select auth.uid())));
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values ('memory-files','memory-files',false,10485760,array['image/jpeg','image/png','image/webp','image/gif','video/mp4','application/pdf']) on conflict(id) do nothing;
create policy "members can read private files" on storage.objects for select to authenticated using(bucket_id='memory-files' and exists(select 1 from public.archive_members m where m.user_id=(select auth.uid())));
create policy "members can upload own files" on storage.objects for insert to authenticated with check(bucket_id='memory-files' and (storage.foldername(name))[1]=(select auth.uid())::text and exists(select 1 from public.archive_members m where m.user_id=(select auth.uid())));
