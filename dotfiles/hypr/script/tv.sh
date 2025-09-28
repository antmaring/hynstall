#!/bin/bash
tvlast=~/.tvlast
action="forward"
function cycle {
 list="dtv rtve la2 atres td 24h sexta neox nova mega a3series eltorotv dw"
 buscar=$(cat $tvlast)  
 arr=($list) 
 encontrado=false 
 for ((i=0; i<${#arr[@]}; i++)); do   
  if [[ "${arr[i]}" == "$buscar" ]]; then     
   if [[ "$action" == "forward" ]];then
   if (( i+1 < ${#arr[@]} )); then       
    echo "${arr[i+1]}"     
   else       
    echo "${arr[0]}"     
   fi     
   else
   if (( i-1 > -1 )); then       
    echo "${arr[i-1]}"     
   else       
    echo "${arr[0]}"     
   fi     
   fi
   encontrado=true     
   break   
  fi 
 done 
 if ! $encontrado; then   
    echo "${arr[0]}" 
 fi
}

function vertv {
 case $1 in
    "rtve"|"tv1"|"1")
    echo "rtve" > $tvlast 
    channel="https://rtvelivestream.rtve.es/rtvesec/la1/la1_main_dvr.m3u8"
    ;;
    "tv2"|"la2"|"2")
    echo "la2" > $tvlast 
    channel="https://rtvelivestream.rtve.es/rtvesec/la2/la2_main_dvr.m3u8"
    ;;
    "a3"|"atres"|"3")
    echo "atres" > $tvlast 
    stream="https://www.atresplayer.com/directos/antena3/"
    ;;
    "td")
    echo "td" > $tvlast 
    channel="https://rtvelivestream.rtve.es/rtvesec/tdp/tdp_main_dvr.m3u8"
    ;;
    "24"|"24h")
    echo "24h" > $tvlast 
    channel=" https://rtvelivestream.rtve.es/rtvesec/24h/24h_main_dvr.m3u8"
    ;;
    "6"|"sexta")
    echo "sexta" > $tvlast 
    stream="https://www.atresplayer.com/directos/lasexta/"
    ;;
    "neox")
    echo "neox" > $tvlast 
    stream="https://www.atresplayer.com/directos/neox/"
    ;;
    "nova")
    echo "nova" > $tvlast 
    stream="https://www.atresplayer.com/directos/nova/"
    ;;
    "mega")
    echo "mega" > $tvlast 
    stream="https://www.atresplayer.com/directos/mega/"
    ;;
    "3s"|"a3series"|"a3s"|"atress")
    echo "a3series" > $tvlast 
    stream="https://www.atresplayer.com/directos/atreseries/"
    ;;
    "eltorotv"|"torotv"|"toro")
    echo "eltorotv" > $tvlast 
    channel="https://streaming-1.eltorotv.com/lb0/eltorotv-streaming-web/index.m3u8"
    ;;
    "dw")
    echo "dw" > $tvlast 
    stream="https://www.dw.com/en/media-center/live-tv/s-100825"
    ;;
    "off") 
    channel="off"
    ;;
    "dtv") 
    echo "dtv" > $tvlast 
    stream="https://nlb1-live.emitstream.com/hls/3mn7wpcv7hbmxmdzaxap/fragments/live-800/index.m3u8"
    ;;
    *) 
    echo "dtv" > $tvlast 
    stream="https://nlb1-live.emitstream.com/hls/3mn7wpcv7hbmxmdzaxap/fragments/live-800/index.m3u8"
    ;;
 esac

 if [[ "$channel" == "off" ]]; then 
    pkill mpv
 elif [[ -v channel ]];then
    pkill mpv
    mpv $channel
 elif [[ -v stream ]];then
    pkill mpv
    streamlink --player mpv $stream best
 fi
}
if [ -z "$1" ]; then
param=$(cycle)
action="forward"
echo $param > $tvlast 
vertv $param
elif [ "$1" == "b" ]; then
action="back"
param=$(cycle)
vertv $param
else
vertv $1
fi
