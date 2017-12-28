# A backup/restore image for MySQL and S3

Work in progress - there's no backup functionality yet. This is only tested on Ceph.

* Based on Alpine 3.3

````
docker run --env-file test.env --net=host -it docker-mysql-s3-backup-restore
````

> test.env
````
AWS_ACCESS_KEY=<aws-access-key>                           
AWS_SECRET_KEY=<aws-secret-key>
AWS_HOST_BUCKET=%(bucket)s.<ceph-host>:<ceph-port>
AWS_HOST_BASE=<ceph-host>:<ceph-port>
MYSQL_HOST=<mysql-host>
MYSQL_USER=<mysql-username>
MYSQL_PASSWORD=<mysql-passwd>
MYSQL_DATABASE=<destination mysql-db>
BACKUP_BUCKET=<s3://bucket-containing-backups>
RESTORE_FILENAME=<name of file to restore in the backup-bucket>
DROP_DB_IF_EXISTS=<false|true>

````
## Restore-flow

* Validate settings
* Download backup into /tmp
* Drop MYSQL_DATABASE if DROP_DB_IF_EXISTS=true
* Create MYSQL_DATABASE
* Populate MYSQL_DATABASE
* Delete downloaded sql file

## TODO

* Custom MySQL settings (missing PORT)
* More error checking
* Allow restoring from a directory (deal with multiple *.sql)
* Can probably remove the template .s3cfg and pass via cmdline
* Backup ;)
* Seeding Galera nodes
