# vaultwarden

## backups
Encrypted backups are currently made by `bruceforce/vaultwarden-backup` image.  
See the docs and docker-compose.yml for details.  
Backups are stored in cloud by rclone.  
See `common/rclone/README.md` and `services/vw/volumes/config/rclone_cron`. 

To restore a backup refer to https://github.com/Bruceforce/vaultwarden-backup/tree/main?tab=readme-ov-file#restore

Backup restoration example:

```sh
cd ~/home-server/services/vw
rm -rf volumes/state/data/*
sudo gpg -o backup.tar.xz --decrypt volumes/state/backup/2025-10-05-070000_backup.tar.xz.gpg
# enter backup encryption password/key passphrase

tar -xJvf backup.tar.xz -C volumes/state/data/
sudo rm backup.tar.xz
```