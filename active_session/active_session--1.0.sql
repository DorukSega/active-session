CREATE TABLE active_sessions (
  recorded_at      timestamp with time zone default now(),
  datid            oid,
  datname          name,
  pid              integer,
  leader_pid       integer,
  usesysid         oid,
  usename          name,
  application_name text,
  client_addr      inet,
  client_hostname  text,
  client_port      integer,
  backend_start    timestamp with time zone,
  xact_start       timestamp with time zone,
  query_start      timestamp with time zone,
  state_change     timestamp with time zone,
  wait_event_type  text,
  wait_event       text,
  state            text,
  backend_xid      xid,
  backend_xmin     xid,
  query_id         bigint,
  query            text,
  backend_type     text
);

CREATE OR REPLACE FUNCTION log_active_sessions()
RETURNS void AS $$
BEGIN
  INSERT INTO active_sessions
  SELECT now(), *
  FROM pg_stat_activity;
END;
$$ LANGUAGE plpgsql;

-- requires pg_cron
--CREATE EXTENSION IF NOT EXISTS pg_cron;
GRANT USAGE ON SCHEMA cron TO postgres;
GRANT ALL PRIVILEGES ON TABLE cron.job TO postgres;

SELECT cron.schedule(
  'log_active_sessions_job',
  '* * * * *',
  $$ SELECT log_active_sessions(); $$
);

CREATE OR REPLACE FUNCTION update_log_interval(job_name TEXT, new_interval TEXT)
RETURNS void AS $$
BEGIN
  UPDATE cron.job
  SET schedule = new_interval
  WHERE jobname = job_name;
END;
$$ LANGUAGE plpgsql;