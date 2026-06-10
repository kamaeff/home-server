## GIS

Here are:
- geopulse for location history/timeline
- photon for reverse geocoding for geopulse
- maybe hauk for live location sharing

### Photon import
1. Download needed region dumps (.jsonl.zst) from https://download1.graphhopper.com/public/index.html
2. Put them into $APP_DATA/photon/import
3. Run `docker compose run photon import-json` to import dumps. This will remove existing database. This can take a while.

