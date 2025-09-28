#!/bin/bash

wspace=$1
CONFIG=~/.config/hypr/workspaces.conf

hyprctl dispatch workspace $wspace

WORKSPACE=$(awk -v ws="$wspace" -F'name: "' '
    $0 ~ "workspace = "ws"," {
        split($2, a, "\"")
        print a[1]
    }
' "$CONFIG")

if [ -z "$WORKSPACE" ]; then
    message="$wspace"
else
    app=$(hyprctl activewindow | grep -oP 'class:\s+\K\S+')
    if [ -z "$app" ]; then
        message="$wspace :|: $WORKSPACE"
    else
        message="$wspace :|: $WORKSPACE > $app"
    fi
fi

notify-send -u normal "Escritorio" "$message" -i ~/.config/hypr/icons/workspacec.png


