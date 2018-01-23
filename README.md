# A backup/restore image for MySQL and S3

Work in progress

* Based on Alpine
* Tested on Ceph only

````
docker run --env-file test.env --net=host -it docker-mysql-s3-backup-restore
````

> test.env
````
MODE=<backup|restore>
S3_ACCESS_KEY=<aws-access-key>                           
S3_SECRET_KEY=<aws-secret-key>
S3_HOST_BUCKET=%(bucket)s.<ceph-host>:<ceph-port>
S3_HOST_BASE=<ceph-host>:<ceph-port>
S3_BACKUP_BUCKET=<s3://bucket-containing-backups>
S3_RESTORE_FILENAME=<name of file to restore in the backup-bucket>
MYSQL_HOST=<mysql-host>
MYSQL_USER=<mysql-username>
MYSQL_PASSWORD=<mysql-passwd>
MYSQL_DATABASE=<destination mysql-db>
MYSQL_DROP_DB_IF_EXISTS=<false|true>
MYSQL_EXIT_SUCCESS_IF_DB_EXISTS=<false|true>
MYSQL_ALLOW_DB_OVERWRITE=<false|true>
````
## Restore-flow

* Validate settings
* Download backup into /tmp
* Drop MYSQL_DATABASE if DROP_DB_IF_EXISTS=true
* Create MYSQL_DATABASE
* Populate MYSQL_DATABASE
* Delete downloaded sql file

## Backup-flow

* Validate settings
* Mysqldump bucket into /tmp
* Gzip backup dump file
* Push to BACKUP_BUCKET
* Delete dump file

## TODO

* More error checking
* printf doesn't flush without newline
* Allow restoring from a directory (deal with multiple *.sql)
* Can probably remove the template .s3cfg and pass via cmdline
* Seeding Galera nodes
* Options for backup/restore filenames (date-format? no-format?)
