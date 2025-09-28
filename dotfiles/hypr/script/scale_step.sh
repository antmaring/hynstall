#!/bin/bash

STEP=0.25
MIN=0.75
MAX=2.0

# Obtener nombre y escala del monitor activo
read MON CUR <<<$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | "\(.name) \(.scale)"')

if [[ -z "$MON" || -z "$CUR" ]]; then
    echo "No se pudo detectar el monitor activo"
    exit 1
fi

if [[ $1 == "up" ]]; then
    NEW=$(echo "$CUR + $STEP" | bc -l)
elif [[ $1 == "down" ]]; then
    NEW=$(echo "$CUR - $STEP" | bc -l)
else
    echo "Uso: $0 [up|down]"
    exit 1
fi

# Forzar redondeo al múltiplo de 0.25 más cercano
NEW=$(printf "%.2f" $(echo "scale=2; ( ( $NEW / $STEP + 0.5 )/1 ) * $STEP" | bc))

# Limitar rango
if (( $(echo "$NEW < $MIN" | bc -l) )); then
    NEW=$MIN
elif (( $(echo "$NEW > $MAX" | bc -l) )); then
    NEW=$MAX
fi

hyprctl keyword monitor "$MON, preferred, auto, $NEW"

