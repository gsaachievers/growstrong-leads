-- Run this once in Supabase SQL Editor if gsa_leads already exists.
-- Existing leads remain unchanged; their email will be NULL.
alter table public.gsa_leads add column if not exists email text;
-- Include email in the public form's allowed insert columns.
revoke insert on public.gsa_leads from anon;
grant insert (parent_name,mobile,email,child_name,child_age,center,program,source,notes) on public.gsa_leads to anon;
