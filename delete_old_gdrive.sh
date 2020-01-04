#!/bin/bash

# This script lists all files older than a week and delete each one from GDrive
# Credit: Rodrigo Silva - https://github.com/rdsilva

exec &>> /home/postgres/excluded-logs.txt

export PATH=/etc/go/bin:$PATH

date=`date +%Y-%m-%d --date="1 week ago"`

for file in `gdrive list -m 30000 -q "createdTime < '2019-12-29' and trashed = false and mimeType = 'application/x-gzip' or mimeType = 'text/plain'" --no-header | sed -e 's/\s.*$//'`;
do
	echo ${file}
	gdrive delete ${file}
done


