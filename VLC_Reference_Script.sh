OUTPUT_LOG=${0}.log
PORT="test4"


FPS="25" # "25.00" "26.63" "53.26" "54.00"
WIDTH="480"
HEIGHT="320"
# VLC="/usr/local/viotech/bin/vlc"
  VLC="/usr/bin/vlc"

${VLC} --version 2>/dev/null | grep -q "VLC version 2.0"
if [[ $? == 0 ]]; then
    ENABLE_AAC="--sout-ffmpeg-strict=-2"  #
else 
    ENABLE_AAC="--sout-avcodec-strict=-2" # In version 2.2 the option name changed
fi
PID_AUDIO="0x290" # "657" # "0x291"

QUIT_AFTER_END="vlc://quit"
export LD_LIBRARY_PATH="/usr/lib:/usr/local/viotech/lib:"

OPTS="--file-caching=2048" # Improves performance.

dir_l=`find /opt/vlc_viotech/lib/vlc/plugins -type d`
for dir in ${dir_l}; do
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${dir}"
done

if [ ! -d streaming ]; then mkdir streaming ; fi
rm -f streaming/${PORT}* /var/www/streaming/${PORT}*
                                                 # Locatel comments
  INPUT="/home/earizon/TV_TS_Examples/BBC-HD.ts" # test 3 --> This one is "Black screen" and millions of errors in syslog (stream is fine on STB/vlc)
VERBOSITY="-vvvv" # Verbosity level
EXTERNAL_IP="192.168.1.12"

  ACODEC="aac"
TS_FORMAT="${PORT}-########.ts"
LIVEHTTP_OPTS=""
LIVEHTTP_OPTS="${LIVEHTTP_OPTS}seglen=5,delsegs=true,numsegs=10,"
LIVEHTTP_OPTS="${LIVEHTTP_OPTS}index=./streaming/${PORT}.m3u8,index-url=http://192.168.1.12/streaming/${TS_FORMAT},"
# LIVEHTTP_OPTS="${LIVEHTTP_OPTS}key-uri=/streaming/AES128.key,key-file=/home/earizon/AlicanteServer/streamingAES128.key"
# key-loadfile=/home/earizon/AlicanteServer/streaming/key_loadfile.map
if true ; then
    SOUT="" # Stream Output Transcodage (SOUT) options
    SOUT="${SOUT}#transcode{threads=1,fps=${FPS},vcodec=h264,vb=410,vecn=x264{aud,profile=baseline,crf=30},acodec=${ACODEC},ab=92,channels=2,height=${HEIGHT},width=${WIDTH}}"
    SOUT="${SOUT}:duplicate{"
        SOUT="${SOUT}dst=std{"
              SOUT="${SOUT}access=livehttp{${LIVEHTTP_OPTS}},"
              SOUT="${SOUT}mux=ts{use-key-frames},"
              SOUT="${SOUT}dst=streaming/${TS_FORMAT}"
            # SOUT="${SOUT}access=file,"
            # SOUT="${SOUT}dst=deleteme.ts,"
            SOUT="${SOUT}}"
    SOUT="${SOUT}}"
fi

  ${VLC} ${VERBOSITY} ${OPTS} ${ENABLE_AAC} -I dummy ${INPUT} ${QUIT_AFTER_END} --sout-ts-pid-audio=${PID_AUDIO} --sout "${SOUT}" 2>&1 | tee /tmp/l1
