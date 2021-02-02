OUTPUT_LOG=${0}.log
echo "logs: "
echo '   cat tests/vlc_transcoding_test.sh.log | grep -v "waiting for " | grep -v "demux warning" |  vim - '
echo ' Search for '
echo '   "transcoding from fcc=.eac3. to fcc=..." '
echo '   "cannot find audio encoder" '
echo ""
echo "Do not forget:"
echo "mv streaming/test* /var/www/streaming/"

rm -f streaming/test1* /var/www/streaming/test1*
rm -f ${OUTPUT_LOG}
exec 1>>${OUTPUT_LOG} 2>&1
INPUT="tests/france2.ts"
V="-vvvv"
EXTERNAL_IP=`export LC_ALL=C; ifconfig eth0 | grep "inet.ad" | cut -d ":" -f 2 | sed -r "s/ +Bcast//"`
# Notes: pid-auido: fra: 230,qaa=231, qad=232
if false ; then
    # Next test fails to generate audio ouput with audio input == ac3 and audio output == acc (acodec=aac).
    # - It works fine with acodec=ac3 or no acodec option at all (no transcoding)
    SOUT=""
    SOUT="${SOUT}#transcode{threads=1,fps=25,vcodec=h264,vb=410,vecn=x264{aud,profile=baseline,crf=30},acodec=acc,ab=192,height=320,width=480}"
    SOUT="${SOUT}:duplicate{"
               SOUT="${SOUT}dst=std{"
                       SOUT="${SOUT}access=livehttp{seglen=5,delsegs=true,numsegs=30,index=./streaming/test1.m3u8,index-url=http://${EXTERNAL_IP}/streaming/test1-########.ts},"
                       SOUT="${SOUT}mux=ts{use-key-frames},"
                       SOUT="${SOUT}dst=streaming/test1-########.ts"
                      SOUT="${SOUT}}"
              SOUT="${SOUT}}"
    echo "dev_log: SOUT: ${SOUT}"
    vlc ${V} -I dummy ${INPUT} vlc://quit --sout "${SOUT}"
    echo "dev_log: command vlc ${V} -I dummy ${INPUT} vlc://quit --sout \"${SOUT}\""
fi

if true ; then 
    SOUT=""
    SOUT="${SOUT}#transcode{threads=1,fps=25,vcodec=h264,vb=410,vecn=x264{aud,profile=baseline,crf=30},acodec=mp4a,ab=92,channels=2,samplerate=48000,pid-audio=230,height=160,width=240}"

    SOUT="${SOUT}:duplicate{"
               SOUT="${SOUT}dst=std{"
                       SOUT="${SOUT}access=livehttp{seglen=5,delsegs=true,numsegs=30,index=./streaming/test1.m3u8,index-url=http://${EXTERNAL_IP}/streaming/test1-########.ts},"
                       SOUT="${SOUT}mux=ts{use-key-frames},"
                       SOUT="${SOUT}dst=streaming/test1-########.ts"
                      SOUT="${SOUT}}"
              SOUT="${SOUT}}"
    echo "dev_log: SOUT: ${SOUT}"
    vlc ${V} -I dummy ${INPUT} vlc://quit --sout "${SOUT}"
    echo "dev_log: command vlc ${V} -I dummy ${INPUT} vlc://quit --sout \"${SOUT}\""
fi

