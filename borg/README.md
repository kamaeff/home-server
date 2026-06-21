Better backup scripts are needed. 
Something that either:
- stops database containers before backing up their data (e.g. through docker-socket-proxy if I still want to keep everything dockerized)
- runs pg_dumpall or analogous command to dump databases

It's also worth looking at [immich's](https://docs.immich.app/administration/backup-and-restore) and other services documentation on backups. 

