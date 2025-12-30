# vaultwarden

## backups
Encrypted backups are currently made by `bruceforce/vaultwarden-backup` image.  
See the docs and docker-compose.yml for details.  
Backups are stored in cloud by rclone.  
See `rclone/README.md` and `rclone/cron-scripts/vw-backup.sh`. 

To restore a backup refer to https://github.com/Bruceforce/vaultwarden-backup/tree/main?tab=readme-ov-file#restore

Backup restoration example:

```sh
(
    set -ue
    cd "${APP_DATA}/vw"
    rm -rf data/*
    sudo gpg -o backup.tar.xz --decrypt backup/2025-10-05-070000_backup.tar.xz.gpg
    # enter backup encryption password/key passphrase

    tar -xJvf backup.tar.xz -C data/
    sudo rm backup.tar.xz
)
```
