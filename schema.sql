-- Run in Supabase SQL Editor. Staff must be invited/created in Authentication > Users.
create extension if not exists pgcrypto;
create table if not exists public.gsa_leads (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  parent_name text not null check (length(trim(parent_name)) between 2 and 120),
  email text,
  mobile text not null check (length(trim(mobile)) between 8 and 20),
  child_name text,
  child_age numeric(4,1) check (child_age between 0 and 18),
  center text not null check (center in ('Greater Noida West','Lucknow')),
  program text not null,
  source text not null default 'QR Code',
  notes text,
  status text not null default 'New' check (status in ('New','Contacted','Trial Scheduled','Converted','Not Interested')),
  follow_up_date date,
  updated_at timestamptz not null default now()
);
create index if not exists gsa_leads_created_at_idx on public.gsa_leads(created_at desc);
create index if not exists gsa_leads_center_idx on public.gsa_leads(center);
alter table public.gsa_leads enable row level security;
-- Anonymous visitors may only insert, never select or edit.
drop policy if exists "Public lead submissions" on public.gsa_leads;
create policy "Public lead submissions" on public.gsa_leads for insert to anon with check (
  status = 'New' and follow_up_date is null
);
-- Signed-in team members can read/update. Only invite trusted staff to Supabase Auth.
drop policy if exists "Staff read leads" on public.gsa_leads;
create policy "Staff read leads" on public.gsa_leads for select to authenticated using (true);
drop policy if exists "Staff update leads" on public.gsa_leads;
create policy "Staff update leads" on public.gsa_leads for update to authenticated using (true) with check (true);
-- Prevent anonymous clients from setting internal fields at INSERT time.
revoke insert on public.gsa_leads from anon;
grant insert (parent_name,mobile,email,child_name,child_age,center,program,source,notes) on public.gsa_leads to anon;
grant select, update on public.gsa_leads to authenticated;
-- Optional: avoid exposing internal staff edits to anonymous callers.
