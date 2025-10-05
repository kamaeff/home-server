# rclone

This is rclone with cron for regular uploads to cloud services.  
To enable uploading data of a service:
- add `rclone_cron` to its `volumes/config`
- inside of `rclone_cron` create a same-named pair of .sh and .crontime files (there may be as many pairs as needed, they all will be added to crontab)
- write rclone script in .sh file
- write cron expression in .crontime file. Lines with comments should start with `#`. No inline comments allowed. 
- add necessary environment variables to the global `.env` file
- mount `rclone_cron` as rw volume and your service's volume as read only volume to `rclone` service in global `docker-compose.yml`