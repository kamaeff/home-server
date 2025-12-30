# rclone with cron

That's it. Rclone with cron.

Scripts for cron should be stored in `cron-scripts/` which is mounted as read-only `/cron-scripts`.
`crontab` is mounted as read only `/etc/crontabs/root`.


To configure rclone run from the root directory of the repo:
```bash
docker compose run --rm rclone config
```

Directories containg files to be copied to the cloud are mounted as read only.
