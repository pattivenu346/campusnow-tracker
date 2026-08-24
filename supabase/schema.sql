-- Campus Workboard — Supabase schema (v2: multi-assign + teams)
-- Run this in the Supabase SQL Editor (https://supabase.com/dashboard → SQL Editor)

-- ============================================================
-- MIGRATION (run ONCE if you already have the old tasks table)
-- This converts assigned_to from text → text[] safely.
-- ============================================================
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'tasks' AND column_name = 'assigned_to'
    AND data_type = 'text'  -- only migrate if still plain text
  ) THEN
    ALTER TABLE public.tasks ALTER COLUMN assigned_to TYPE text[] USING ARRAY[assigned_to];
    RAISE NOTICE 'Migrated assigned_to from text → text[]';
  ELSE
    RAISE NOTICE 'assigned_to is already text[] — skipping migration';
  END IF;
END $$;

-- ============================================================
-- TASKS TABLE (for fresh installations)
-- ============================================================
create table if not exists public.tasks (
  id text primary key,
  title text not null,
  description text not null default '',
  assigned_to text[] not null default '{}',
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

alter table public.tasks enable row level security;
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on table public.tasks to anon, authenticated;
drop policy if exists "workboard task access" on public.tasks;
create policy "workboard task access" on public.tasks
  for all to anon, authenticated
  using (true) with check (true);

-- ============================================================
-- TEAMS TABLE (new)
-- ============================================================
create table if not exists public.teams (
  id text primary key,
  name text not null,
  member_ids text[] not null default '{}',
  color text not null default '#6366f1',
  created_at timestamptz not null default now()
);

alter table public.teams enable row level security;
grant select, insert, update, delete on table public.teams to anon, authenticated;
drop policy if exists "workboard team access" on public.teams;
create policy "workboard team access" on public.teams
  for all to anon, authenticated
  using (true) with check (true);

-- Optional: enable Supabase Realtime
alter publication supabase_realtime add table public.tasks;
alter publication supabase_realtime add table public.teams;
