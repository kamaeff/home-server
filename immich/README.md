### Storage template
`{{y}}-{{MM}}/{{y}}-{{MM}}-{{dd}}-{{hh}}:{{mm}}-{{filename}}`


### Settings
- Disable transcoding in `Administration > Settings > Video Transcoding Settings > Transcode Policy > Don't transcode`
- For google-compressed photos transcoding may be needed from VP9 to maybe h.264 to be playable in safari and immich mobile
- Switch OCR model in `Administration > Settings > Machine Learning Settins > OCR > OCR Model` to `PP-OCRv5_mobile (Russian, Belarusian, Ukrainian and English)`
- `Administration > Settings > Image Settings`
  - Thumbnail Settings: WebP 260p quality:65 (maybe lower)
  - Preview Settings: WebP 1440p quality:80

Optionally:
- set up email notifications in `Administration > Settings > Notification Settings > Email`


#### Mobile app settings
Backup include: Recents
Backup exclude: Recently Saved, Screenshots, Screen Recordings
