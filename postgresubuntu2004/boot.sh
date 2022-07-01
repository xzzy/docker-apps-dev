#!/bin/bash
  
# Start the first process
env > /etc/.cronenv

service cron start &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start cron: $status"
  exit $status
fi
echo "listen_addresses = '*'" >> /etc/postgresql/12/main/postgresql.conf
echo "host    all             all             172.17.0.1/8            md5" >> /etc/postgresql/12/main/pg_hba.conf
echo "host    all             all             10.17.0.1/8            md5" >> /etc/postgresql/12/main/pg_hba.conf
mv /var/lib/postgresql /var/lib/postgresql-docker-version
ln -s /data/postgresql-lib/ /var/lib/postgresql

mv /etc/postgresql /etc/postgresql-docker-version
ln -s /data/postgresql-etc/ /etc/postgresql

mv /etc/postgresql-common /etc/postgresql-common-docker-version
ln -s /data/postgresql-common-etc/ /etc/postgresql-common

mv /var/log/postgresql /var/log/postgresql-docker-version
ln -s /data/postgresql-log /var/log/postgresql
chown root.postgres /data/postgresql-log
chmod 775 /data/postgresql-log
chmod 775 /data/postgresql-log
chmod 755 /app/create-new-postgres.sh

# Start the second process
service postgresql start &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start postgresql: $status"
  exit $status
fi
bash
