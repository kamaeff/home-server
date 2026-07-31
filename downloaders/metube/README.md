I'm not well familiar with video encodings.  
Current (2026-07-30) presets are suboptimal, I guess.  
I mean even youtube's avc1 720p60fps are comparable in size to my hevc 720p24fps transcodes.  

I would like to tweak some encoder-specific options in the future, if I get to dive deep into codecs. I would like to have hardware better suited for video decoding/encoding. I suspect that libx265 can produce better results, but running it on N150 takes eternity. 
I also would like to use `lanczos` to scale frames, as stackexchange and chatgpt suggest, but again, it requires running it on CPU, which is slow.

Currently the whole decoding-scaling-encoding pipeline is hardware-accelerated via VAAPI, which gives better speed and less heat. Videos from youtube are decoded with `-hwaccel` option, all the frames are already in the video memory in right format, then vaapi scales them, then `hevc_vaapi` encodes them, without ever copying between main and video memory. 

I couldn't set up QSV with metube. I guess, QSV needs r/w acces to `/dev/dri/card0`, and it requires `video` group. 
Gonna test it later with `video` group added.
https://github.com/alexta69/metube/discussions/1045#discussioncomment-17852656
