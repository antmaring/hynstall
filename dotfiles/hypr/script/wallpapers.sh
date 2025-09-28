#!/bin/bash
WALLPAPER_DIR="$HOME/.Images/Wallpapers/hypr"
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n1)
swww img "$(echo "$WALLPAPER" | shuf -n1)" --transition-duration 8 --transition-type wave --transition-angle 270
