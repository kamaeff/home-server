### Storage template
`{{y}}-{{MM}}/{{y}}-{{MM}}-{{dd}}-{{hh}}:{{mm}}-{{filename}}`


### Settings
- Disable transcoding in `Administration > Settings > Video Transcoding Settings > Transcode Policy > Don't transcode`
- Switch OCR model in `Administration > Settings > Machine Learning Settins > OCR > OCR Model` to `PP-OCRv5_mobile (Russian, Belarusian, Ukrainian and English)`
- `Administration > Settings > Image Settings`
  - Thumbnail Settings: WebP 260p quality:65 (maybe lower)
  - Preview Settings: WebP 1440p quality:80

Optionally:
- set up email notifications in `Administration > Settings > Notification Settings > Email`


#### Mobile app settings
Backup include: Recents
Backup exclude: Recently Saved, Screenshots, Screen Recordings
