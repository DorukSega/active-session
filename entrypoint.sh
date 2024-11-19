#!/bin/bash

#install pg_cron for cronjobs
cat <<EOT >> /var/lib/postgresql/data/postgresql.conf
shared_preload_libraries='pg_cron'
cron.database_name = 'postgres'
EOT

cd /home/active_session
make && make install
cd /

chown -R postgres:postgres /var/lib/postgresql/data
#su postgres -c "/usr/lib/postgresql/*/bin/pg_ctl -D /var/lib/postgresql/data -l /var/lib/postgresql/logfile start"
su postgres -c "/usr/lib/postgresql/*/bin/pg_ctl -D /var/lib/postgresql/data -l /var/lib/postgresql/logfile restart"

tail -f /dev/null # keep the container running
