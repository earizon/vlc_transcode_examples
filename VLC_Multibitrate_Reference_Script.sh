#!/bin/bash
killall -9 vlc
dst1='transcode{width=640,height=480,vcodec=h264,acodec=mp3,vb=800,ab=128,deinterlace}:standard{access=http,mux=ts,dst=127.0.0.1:8081/}'
dst2='transcode{width=320,height=240,vcodec=h264,acodec=mp3,vb=400,ab=128,deinterlace}:standard{access=http,mux=ts,dst=127.0.0.1:8082/}'
dst3='transcode{width=160,height=120,vcodec=h264,acodec=mp3,vb=200,ab=128,deinterlace}:standard{access=http,mux=ts,dst=127.0.0.1:8083/}'
DEBUG="" # -vvv
INPUT="tests/test1.ts"
  vlc -I dummy ${DEBUG} ${INPUT} --sout "#duplicate{dst=\"${dst1}\",dst=\"${dst2}\",dst=\"${dst3}\"}" &
sleep 1
# vlc "http://127.0.0.1:8081/" &
# vlc "http://127.0.0.1:8082/" &
# vlc "http://127.0.0.1:8083/" &
