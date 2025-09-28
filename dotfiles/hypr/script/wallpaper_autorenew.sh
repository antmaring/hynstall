#!/usr/bin/env bash

# Cada cuántos segundos cambiar el wallpaper
INTERVAL=60 # 3600 segundos

while true; do
    ~/.config/hypr/script/wallpapers.sh
    sleep $INTERVAL
done

