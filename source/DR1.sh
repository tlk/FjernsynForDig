#!/bin/sh
/Applications/VLC.app/Contents/MacOS/VLC --quiet --rtsp-tcp rtsp://streamer-01.dr.nordija.dk:80/dr1low rtsp://streamer-01.dr.nordija.dk:80/dr1high --config=$HOME/Library/Preferences/VLC/vlcrc --no-embedded-video
