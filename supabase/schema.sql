-- Campus Workboard — Supabase schema
-- Run this in the Supabase SQL Editor (https://supabase.com/dashboard → SQL Editor)

create table if not exists public.tasks (
  id text primary key,
  title text not null,
  description text not null default '',
  assigned_to text not null,
  deadline date not null,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  status text not null,
  priority text not null,
  notes text not null default '',
  completed_at timestamptz,
  previous_status text,
  moved_to_backlog_at timestamptz,
  submitted_for_review_at timestamptz
);

-- Row Level Security
alter table public.tasks enable row level security;

-- Table-level grants for anon (publishable key) and authenticated roles
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on table public.tasks to anon, authenticated;

-- Permissive RLS policy (idempotent: drops first if exists)
drop policy if exists "workboard task access" on public.tasks;
create policy "workboard task access" on public.tasks
  for all to anon, authenticated
  using (true) with check (true);

-- Optional: enable Supabase Realtime for this table
-- Refresh-based cross-device sync works without this.
alter publication supabase_realtime add table public.tasks;
