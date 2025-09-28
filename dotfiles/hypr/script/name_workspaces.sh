#!/bin/bash

MONITOR=$(hyprctl activewindow -j | jq -r '.monitor')
if [[ -z "$MONITOR" || "$MONITOR" == "null" ]]; then
    TITLE="Escritorio"
    WORKSPACES="Ninguna ventana activa"
else
    echo "MONITOR: $MONITOR"
    echo "monitor1: $monitor1"
    echo "monitor2: $monitor2"
    echo "monitor3: $monitor3"
    case "$MONITOR" in
        0) 
            MONITOR="${monitor1}"
        ;;       
        1) 
            MONITOR="${monitor2}"
        ;;     
        2) 
            MONITOR="${monitor3}"
        ;;    
    esac
    CONFIG="$HOME/.config/hypr/workspaces.conf"
    WORKSPACES=$(grep "monitor:${MONITOR}" ~/.config/hypr/workspaces.conf | sed -E 's/.*workspace *= *([0-9]+),[[:space:]]*name:[[:space:]]*"([^"]+)".*/\1: \2/' | paste -sd', ')
    TITLE="Workspaces:"
fi

notify-send -u normal "$TITLE" "$WORKSPACES" -i ~/.config/hypr/icons/workspacec.png


