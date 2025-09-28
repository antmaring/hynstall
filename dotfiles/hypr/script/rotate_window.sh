#!/usr/bin/env bash
set -euo pipefail

# Requiere: jq

# Monitores ordenados por X (izquierda -> derecha); guardamos ID y nombre
mapfile -t MONS < <(hyprctl -j monitors | jq -r 'sort_by(.x) | .[] | "\(.id)\t\(.name)"')

# Construimos arrays paralelos: ids[] y names[]
ids=()
names=()
for line in "${MONS[@]}"; do
  ids+=( "$(cut -f1 <<<"$line")" )
  names+=( "$(cut -f2 <<<"$line")" )
done
N=${#ids[@]}
(( N > 0 )) || exit 0

# Monitor del cliente activo (ID numérico)
curr_id="$(hyprctl -j activewindow | jq -r '.monitor // empty')"
if [[ -z "${curr_id}" ]]; then
  # Si no hay ventana activa, simplemente rota el foco como fallback
  hyprctl dispatch focusmonitor "${names[0]}"
  exit 0
fi

# Índice del monitor actual dentro del array ordenado
idx=-1
for i in "${!ids[@]}"; do
  if [[ "${ids[$i]}" == "${curr_id}" ]]; then idx=$i; break; fi
done
(( idx >= 0 )) || exit 0

# Siguiente monitor con rotación
next=$(( (idx + 1) % N ))
target_name="${names[$next]}"

# Mover la ventana enfocada y llevar el foco al nuevo monitor
hyprctl dispatch movewindow "mon:${target_name}"
hyprctl dispatch focusmonitor "${target_name}"
