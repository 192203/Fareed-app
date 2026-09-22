-- ميزان V8: تأكيد إعدادات المستندات والإشعارات
create extension if not exists "pgcrypto";

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  body text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.notifications enable row level security;

create table if not exists public.case_documents (
  id uuid primary key default gen_random_uuid(),
  case_id uuid not null references public.cases(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  storage_path text not null,
  uploaded_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

alter table public.case_documents enable row level security;

drop policy if exists "notifications_select_own" on public.notifications;
drop policy if exists "notifications_staff_insert" on public.notifications;
drop policy if exists "notifications_update_own" on public.notifications;

create policy "notifications_select_own"
on public.notifications for select to authenticated
using (user_id = auth.uid() or public.is_staff());

create policy "notifications_staff_insert"
on public.notifications for insert to authenticated
with check (public.is_staff());

create policy "notifications_update_own"
on public.notifications for update to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "case_documents_client_select" on public.case_documents;
drop policy if exists "case_documents_staff_insert" on public.case_documents;
drop policy if exists "case_documents_staff_delete" on public.case_documents;

create policy "case_documents_client_select"
on public.case_documents for select to authenticated
using (user_id = auth.uid() or public.is_staff());

create policy "case_documents_staff_insert"
on public.case_documents for insert to authenticated
with check (public.is_staff());

create policy "case_documents_staff_delete"
on public.case_documents for delete to authenticated
using (public.is_staff());

grant select, insert, update on public.notifications to authenticated;
grant select, insert, delete on public.case_documents to authenticated;

insert into storage.buckets (id, name, public)
values ('case-documents', 'case-documents', false)
on conflict (id) do update set public = false;

drop policy if exists "case_docs_storage_read" on storage.objects;
drop policy if exists "case_docs_storage_staff_insert" on storage.objects;
drop policy if exists "case_docs_storage_delete" on storage.objects;

create policy "case_docs_storage_read"
on storage.objects for select to authenticated
using (
  bucket_id = 'case-documents'
  and (
    public.is_staff()
    or (storage.foldername(name))[1] = auth.uid()::text
  )
);

create policy "case_docs_storage_staff_insert"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'case-documents'
  and public.is_staff()
);

create policy "case_docs_storage_delete"
on storage.objects for delete to authenticated
using (
  bucket_id = 'case-documents'
  and public.is_staff()
);

create index if not exists idx_case_documents_case_id
on public.case_documents(case_id);

create index if not exists idx_notifications_user_id
on public.notifications(user_id);
