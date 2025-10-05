# home-server

My docker-compose powered home server.  
Successor of these repos:
- https://github.com/kamaeff/vaultwarden-caddy-tailscale/tree/master
- https://github.com/kamaeff/openwebui-docker-compose/tree/master

## architecture

- `docker-compose.yml` – main docker compose file
- `common` – common services that can interact, use or be used by other services
- `services` – separate services

Each service contains `volumes` directory. 
- `volumes/config` – volumes used to configure containers. Most of them should be readonly, only modified manually. These subdirectories are designed to be checked out by git.
- `volumes/state` – volumes keeping persistant state of containers between launchecs. Basically any user data. These subdirectories are ignored by git. 

## install
1. Install docker according to official documentation. [For Raspberry Pi OS](https://docs.docker.com/engine/install/debian/). [Postinstall](https://docs.docker.com/engine/install/linux-postinstall/)
2. Clone this repo: `cd ~ && clone git@github.com:kamaeff/home-server.git`
3. Run setup.sh: `cd ~/home-server && ./setup.sh`
4. Proceed by entering tokens and urls needed in config. For vw push credentials read [this](https://github.com/dani-garcia/vaultwarden/wiki/Enabling-Mobile-Client-push-notification#enable-mobile-client-push-notification)
5. Proceed by setting rclone tokens for yandex and google drive

- setup.sh assumes it is run on Raspberry Pi OS
- setup.sh adds healthchecks.io ping to `/etc/cron.d/healthcheck` on host machine
- setup.sh may be used to rebuild locally-built images and pull latest images from hub.

### external access
Fot external access install tailscale:
```sh
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale set --advertise-exit-node --advertise-routes=192.168.31.0/24
sudo tailscale up
```
and then enable routing options from tailscale admin panel

## run
`cd ~/home-server && docker compose up -d`

## update
```sh
cd ~/home-server
docker compose down
docker compose up -d # to trigger backups
docker compose down
docker compose pull
docker compose up -d
```

`setup.sh` may be used instead of `docker compose pull`. It pulls and rebuilds all images that require it. 
Use `docker compose pull <image-name>` to pull separate images. 


## adding new services
- Add new directory inside of `services`
- Place all dockerfiles/compose yamls inside of it
- Add `volumes/config` and `volumes/state` subdirectories
- Include it's `docker-compose.yml` in main `docker-compose.yml`
- Check if you need to add something to common services configs. Common services may include their own readmes
- Check if you need to add some environment variables in `.env` and `.env.example`
- Check if additional steps need to be added to `setup.sh`.
- Check if .gitignore needs to be updated
