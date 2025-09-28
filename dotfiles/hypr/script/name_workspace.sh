#!/bin/bash

wspace=$(hyprctl activewindow | grep -oP 'workspace: \K[0-9]+')

if [ -z "$wspace" ]; then
    message="Ninguna ventana activa"
else
    app=$(hyprctl activewindow | grep -oP 'class:\s+\K\S+')
    CONFIG="$HOME/.config/hypr/workspaces.conf"
    WORKSPACE=$(grep "workspace = $wspace" "$CONFIG" | awk -F'name: "' '{print $2}' | sed 's/".*//')
    message="$wspace :|: $WORKSPACE > $app" 
fi

notify-send -u normal "Escritorio" "$message" -i ~/.config/hypr/icons/workspacec.png


