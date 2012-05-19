#!/bin/bash

#v4l2:// :v4l2-dev=/dev/video0 :v4l2-adev=/dev/dsp1 :v4l2-standard=0 :v4l2-dev=/dev/video0 :v4l2-standard=0 :v4l2-chroma= :v4l2-input=0 :v4l2-audio-input=0 :v4l2-io=1 :v4l2-width=0 :v4l2-height=0 :v4l2-fps=0 :v4l2-adev= :v4l2-audio-method=3 :v4l2-stereo :v4l2-samplerate=48000 :v4l2-caching=300 :v4l2-tuner=0 :v4l2-tuner-frequency=-1 :v4l2-tuner-audio-mode=0 :no-v4l2-controls-reset :v4l2-brightness=-1 :v4l2-contrast=-1 :v4l2-saturation=-1 :v4l2-hue=-1 :v4l2-black-level=-1 :v4l2-auto-white-balance=-1 :v4l2-do-white-balance=-1 :v4l2-red-balance=-1 :v4l2-blue-balance=-1 :v4l2-gamma=-1 :v4l2-exposure=-1 :v4l2-autogain=-1 :v4l2-gain=-1 :v4l2-hflip=-1 :v4l2-vflip=-1 :v4l2-hcenter=-1 :v4l2-vcenter=-1 :v4l2-audio-volume=-1 :v4l2-audio-balance=-1 :no-v4l2-audio-mute :v4l2-audio-bass=-1 :v4l2-audio-treble=-1 :v4l2-audio-loudness=-1 :v4l2-set-ctrls=

#vlc v4l2:// --v4l2-dev "/dev/video0" --v4l2-adev "/dev/dsp1" --v4l2-io 1 --v4l2-width 640 --v4l2-height 480 --v4l2-fps 30 --v4l2-audio-method 3 --v4l2-samplerate 48000 --v4l2-caching 300  --no-v4l2-controls-reset --v4l2-brightness 100 --v4l2-contrast 100 --v4l2-saturation 50 --v4l2-auto-white-balance 50 --v4l2-do-white-balance 50 --v4l2-autogain 80 --v4l2-audio-volume 100 --sout '#transcode{vcodec=theo,vb=800,scale=1,acodec=vorb,ab=128,channels=2}:duplicate{dst=std{access=file,mux=ogg,dst=/media/hda4/webcam/capture.ogg}}'

vlc v4l2:// --verbose --logfile "/tmp/vlc.log" --v4l2-dev "/dev/video0" --v4l2-adev "/dev/dsp1" --sout '#transcode{vcodec=mp4v,vb=1024,scale=1,acodec=mpga,ab=192,channels=2}:duplicate{dst=display,dst=std{access=file,mux=mp4,dst=/media/hda4/webcam/capture.mpg}}'