create table if not exists public.tasks (
  id text primary key, title text not null, description text not null default '', assigned_to text not null, deadline date not null,
  created_at timestamptz not null, updated_at timestamptz not null, status text not null, priority text not null, notes text not null default '',
  completed_at timestamptz, previous_status text, moved_to_backlog_at timestamptz, submitted_for_review_at timestamptz
);
alter table public.tasks enable row level security;
create policy "workboard task access" on public.tasks for all to anon using (true) with check (true);
alter publication supabase_realtime add table public.tasks;
