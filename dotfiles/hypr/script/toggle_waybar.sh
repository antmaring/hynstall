#!/usr/bin/env bash

# Comprobar si waybar está corriendo
if pgrep -x "waybar" > /dev/null; then
    # Si está corriendo, matarlo
    pkill -x "waybar"
else
    # Si no está corriendo, lanzarlo
    waybar &
fi

