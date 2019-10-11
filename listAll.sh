#!/bin/bash

# This script list all tables from all databases from a postgres cluster
# Credit: Rodrigo Silva - https://github.com/rdsilva

for dbase in `psql -qAt -c "SELECT datname FROM pg_database WHERE datistemplate = false;"`;
do
    psql -c "SELECT '$dbase' as data_base, table_schema,table_name FROM information_schema.tables ORDER BY table_schema,table_name;" -d $dbase;
done
