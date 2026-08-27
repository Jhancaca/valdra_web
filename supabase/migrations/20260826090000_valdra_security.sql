-- VALDRA backend boundary. This migration is additive and intentionally has
-- no password or public Storage policy. Set valdra_app's password out of band.
create schema if not exists valdra_private;

create table if not exists valdra_private.valdra_customer_profiles (
  spree_user_id bigint primary key references public.spree_users(id) on delete cascade,
  phone varchar(20) not null check (phone ~ '^\\+[1-9][0-9]{7,14}$'),
  department_code varchar(8) not null,
  municipality_code varchar(16) not null,
  gender varchar(32),
  date_of_birth date not null,
  privacy_consent_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint valdra_customer_profiles_gender_check check (gender is null or gender in ('male', 'female', 'non_binary', 'prefer_not_to_say')),
  constraint valdra_customer_profiles_dob_check check (date_of_birth < current_date)
);
create index if not exists idx_valdra_customer_profiles_department on valdra_private.valdra_customer_profiles (department_code);

do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'valdra_app') then
    create role valdra_app login nosuperuser nobypassrls;
  else
    alter role valdra_app nosuperuser nobypassrls;
  end if;
end $$;

revoke all on schema valdra_private from public, anon, authenticated;
grant usage on schema valdra_private to valdra_app;
revoke all on table valdra_private.valdra_customer_profiles from public, anon, authenticated;
grant select, insert, update, delete on table valdra_private.valdra_customer_profiles to valdra_app;
alter table valdra_private.valdra_customer_profiles enable row level security;
drop policy if exists valdra_app_profile_access on valdra_private.valdra_customer_profiles;
create policy valdra_app_profile_access on valdra_private.valdra_customer_profiles for all to valdra_app using (true) with check (true);

-- Rails is the only application database consumer. Public and Supabase
-- client roles stay deny-by-default; valdra_app receives only CRUD + sequences.
revoke all on all tables in schema public from anon, authenticated;
grant usage on schema public to valdra_app;
grant select, insert, update, delete on all tables in schema public to valdra_app;
grant usage, select, update on all sequences in schema public to valdra_app;

do $$
declare
  table_record record;
begin
  for table_record in
    select n.nspname as schema_name, c.relname as table_name
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where c.relkind = 'r' and c.relrowsecurity and n.nspname = 'public'
  loop
    if not exists (
      select 1 from pg_policies
      where schemaname = table_record.schema_name
        and tablename = table_record.table_name
        and policyname = 'valdra_app_internal_access'
    ) then
      execute format('create policy valdra_app_internal_access on %I.%I for all to valdra_app using (true) with check (true)', table_record.schema_name, table_record.table_name);
    end if;
  end loop;
end $$;

create schema if not exists extensions;
do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_trgm') then
    alter extension pg_trgm set schema extensions;
  end if;
end $$;
grant usage on schema extensions to valdra_app;
alter role valdra_app set search_path = public, valdra_private, extensions;

alter default privileges in schema valdra_private revoke all on tables from public, anon, authenticated;
alter default privileges in schema valdra_private grant select, insert, update, delete on tables to valdra_app;
alter default privileges in schema valdra_private grant usage, select, update on sequences to valdra_app;

-- Storage remains private; Rails accesses it with server-only S3 credentials.
insert into storage.buckets (id, name, public)
values ('catalog-private', 'catalog-private', false)
on conflict (id) do update set public = false;
