#!/usr/bin/env bash

# Obtener todos los monitores en orden
monitors=($(hyprctl -j monitors | jq -r '.[].name'))

# Obtener el monitor activo
active=$(hyprctl -j monitors | jq -r '.[] | select(.focused == true).name')

# Buscar índice del activo
for i in "${!monitors[@]}"; do
    if [[ "${monitors[$i]}" == "$active" ]]; then
        idx=$i
        break
    fi
done

# Calcular siguiente (rotando con %)
next=$(( (idx + 1) % ${#monitors[@]} ))

# Cambiar foco
hyprctl dispatch focusmonitor "${monitors[$next]}"
