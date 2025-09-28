#!/usr/bin/env bash

focused=$(hyprctl activewindow | jq -r '.id')
# Obtener estado actual de fullscreen
fs=$(hyprctl clients | jq -r ".[] | select(.id==$focused).fullscreen")

if [[ "$fs" == "true" ]]; then
    hyprctl dispatch fullscreen off
else
    hyprctl dispatch fullscreen on
fi
