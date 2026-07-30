I'm not well familiar with video encodings.  
Current (2026-07-30) presets are suboptimal, I guess.  
I mean even youtube's avc1 720p60fps are comparable in size to my hevc 720p24fps transcodes.  

I would like to tweak some encoder-specific options in the future, if I get to dive deep into codecs. I would like to have hardware better suited for video decoding/encoding. I suspect that libx265 can produce better results, but running it on N150 takes eternity. 
I also would like to use `lanczos` to scale frames, as stackexchange and chatgpt suggest, but again, it requires running it on CPU, which is slow.

Currently the whole decoding-scaling-encoding pipeline is hardware-accelerated via VAAPI, which gives better speed and less heat. Videos from youtube are decoded with `-hwaccel` option, all the frames are already in the video memory in right format, then vaapi scales them, then `hevc_vaapi` encodes them, without ever copying between main and video memory. 

I couldn't set up QSV with metube. I guess, QSV needs r/w acces to `/dev/dri/card0`, and it requires `video` group. Since metube is run with gosudo with explicit UID:GID userspec, it strips out all the supplementary groups. 
To make QSV work I would need to rewrite the entrypoint to allow supplementary groups. 
I don't like this idea as it requires me to maintain my entrypoint compatibility with the upstream image.

Another solution is to use ACL with setfacl (and udev rule to run setfacl on each boot) giving my UID (1000) access to `/dev/dri/card0` and `/dev/dri/renderD128` without relying on standard Unix file permissions. 

Anyway, VAAPI is doing pretty well, not sure I even need QSV. 
