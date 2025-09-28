#!/bin/bash

# Dirección: left, right, up, down
direction="$1"
[ -z "$direction" ] && direction="right"

# Obtenemos el workspace activo
current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Listamos todas las ventanas del workspace actual
windows=($(hyprctl clients -j | jq -r ".[] | select(.workspace.id==$current_ws) | .id"))

# Obtenemos la ventana actualmente enfocada
focused=$(hyprctl activewindow -j | jq -r '.id')

# Encontramos la posición del foco actual en la lista
for i in "${!windows[@]}"; do
    if [ "${windows[$i]}" == "$focused" ]; then
        current_index=$i
        break
    fi
done

# Calculamos la ventana siguiente según dirección (simple loop)
total=${#windows[@]}
if [ "$direction" == "next" ] || [ "$direction" == "right" ]; then
    next_index=$(( (current_index + 1) % total ))
elif [ "$direction" == "prev" ] || [ "$direction" == "left" ]; then
    next_index=$(( (current_index - 1 + total) % total ))
else
    # Si dirección inválida, movemos al siguiente
    next_index=$(( (current_index + 1) % total ))
fi

# Focuseamos la ventana siguiente
hyprctl dispatch focuswindow "${windows[$next_index]}"

