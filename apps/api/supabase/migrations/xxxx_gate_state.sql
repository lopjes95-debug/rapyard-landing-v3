create table if not exists gate_state (
  id uuid primary key default gen_random_uuid(),
  phase text not null check (phase in ('closed', 'cypher', 'battle')),
  updated_at timestamp with time zone default now()
);

insert into gate_state (phase) values ('closed');
