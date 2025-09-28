#!/bin/bash

WORKSPACE=$1
CONFIG=~/.config/hypr/workspaces.conf

hyprctl dispatch movetoworkspace $WORKSPACE

message=$(awk -v ws="$WORKSPACE" -F'name: "' '
    $0 ~ "workspace = "ws"," {
        split($2, a, "\"")
        print a[1]
    }
' "$CONFIG")

if [ -z "$message" ]; then
    message="$WORKSPACE"
fi

notify-send -u low "Escritorio" "$message" -i ~/.config/hypr/icons/workspacec.png
