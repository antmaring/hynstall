#!/bin/bash

ACTION=$1
KEY=$2   # 1-9 relativo al monitor

# Obtener monitor primario o fallback al primero de la lista
MONITOR=$(hyprctl activewindow -j | jq -r '.monitor')

# Base de workspace según monitor
case "$MONITOR" in
    0) BASE=0 ;;       # workspaces 1-9
    1) BASE=20 ;;      # workspaces 21-29
    2) BASE=30 ;;      # workspaces 31-39
    *) BASE=0 ;;          # fallback
esac

# Calcular workspace final
wspace=$((BASE + KEY))

# Obtener workspaces ocupados (con al menos 1 ventana)
OCCUPIED_WS=$(hyprctl workspaces -j | jq -r '.[] | select(.windows > 0) | .id')

# Ejecutar acción
case "$ACTION" in
    focus)
        # Evitar ir a workspace vacío
        if ! echo "$OCCUPIED_WS" | grep -q "^$wspace$"; then
            echo "Workspace $wspace está vacío, no se cambia."
        else
            hyprctl dispatch workspace $wspace
        fi
        ;;
    move)
        # Mover ventana a workspace aunque esté vacío
        hyprctl dispatch movetoworkspace $wspace
        ;;
esac
CONFIG="$HOME/.config/hypr/workspaces.conf"
WORKSPACE=$(awk -v ws="$wspace" -F'name: "' '
    $0 ~ "workspace = "ws"," {
        split($2, a, "\"")
        print a[1]
    }
' "$CONFIG")

if [ -z "$message" ]; then
    message="$wspace"
else
    app=$(hyprctl activewindow | grep -oP 'class:\s+\K\S+')
    if [ -z "$app" ]; then
        message="$wspace :|: $WORKSPACE"
    else
        message="$wspace :|: $WORKSPACE > $app"
    fi
fi

notify-send -u low "Escritorio" "$message" -i ~/.config/hypr/icons/workspacec.png
