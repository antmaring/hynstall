#!/bin/bash
get_current_sink() {
    current_sink_name=$(pactl list short sinks | awk '$7=="RUNNING"{print $2}')  
    default_sink_name=$(pactl get-default-sink)
    #echo "current name: $current_sink_name"
    #echo "default name: $default_sink_name"
    if [[ "$current_sink_name" != "$default_sink_name" ]];then
        if [[ "$current_sink_name" != "" ]];then
            default_sink_name=$current_sink_name
            pactl set-default-sink "$default_sink_name"
        fi
    fi
    #echo "current name: $default_sink_name"
    sink=$(pactl list short sinks | awk -v sink="$default_sink_name" '$2 == sink {print $1}')
    echo "$sink"
}

get_current_volume() {
    sink=$(get_current_sink)
    echo "$(pactl get-sink-volume ${sink})"
    #current_volume=$(pactl list sinks | grep -A 10 "Sink #$sink" | grep 'Volume' | head -n 1 | awk '{print $5}')
    #echo "${current_volume}"
}

50() {
    sink=$(get_current_sink)
    #echo "sink: $sink"
    pactl set-sink-volume "$sink" 50%
}

100() {
    sink=$(get_current_sink)
    #echo "sink: $sink"
    pactl set-sink-volume "$sink" 100%
}

volume_up() {
    sink=$(get_current_sink)
    #echo "sink: $sink"
    pactl set-sink-volume "$sink" +5%
    notify-send -u low "PulseAudio" "Volumen: $(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/%/ {print $2}' | head -n1)" -i ~/.config/hypr/icons/sound.png
}

volume_down() {
    sink=$(get_current_sink)
    #echo "sink: $sink"
    pactl set-sink-volume "$sink" -5%
    notify-send -u low "PulseAudio" "Volumen: $(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/%/ {print $2}' | head -n1)" -i ~/.config/hypr/icons/sound.png
}

rotate() {
    SINKS=($(pactl list short sinks | awk '{print $2}'))
    CUR=$(pactl list short sinks | awk '$7=="RUNNING"{print $2; exit}')
    if [[ -z "$CUR" ]]; then
        CUR=$(pactl get-default-sink)
    fi
    for i in "${!SINKS[@]}"; do
        if [[ "${SINKS[$i]}" == "$CUR" ]]; then
            IDX=$i
            break
        fi
    done
    NEXT=$(( (IDX + 1) % ${#SINKS[@]} ))
    NEXT_SINK=${SINKS[$NEXT]}
    MUTE=$(pactl list sinks | awk -v sink="$NEXT_SINK" '
    $0 ~ "Name: "sink {f=1} 
    f && /Mute:/ {print $2; exit}
    ')
    if [[ "$MUTE" == "yes" ]]; then
        pactl set-sink-mute "$NEXT_SINK" 0
    fi
    #echo "NEXT SINK: $NEXT_SINK"
    pactl set-default-sink "$NEXT_SINK"
        notify-send -u normal "PulseAudio" "$CUR 
        >>
        $NEXT_SINK" -i ~/.config/hypr/icons/sound.png
        for SINK_INPUT in $(pactl list short sink-inputs | awk '{print $1}'); do
            pactl move-sink-input "$SINK_INPUT" "$NEXT_SINK"
        done
    }

    toggle_mute() {
        sink=$(get_current_sink)
        pactl set-sink-mute $sink toggle
        notify-send -u low "PulseAudio" "$(pactl get-sink-mute $sink)" -i ~/.config/hypr/icons/sound.png
}

case "$1" in
    sink)
        get_current_sink
        ;;
    volume)
        get_current_volume
        ;;
    100)
        100
        ;;
    50)
        50
        ;;
    up)
        volume_up
        ;;
    down)
        volume_down
        ;;
    mute)
        toggle_mute
        ;;
    rotate)
        rotate
        ;;
esac
