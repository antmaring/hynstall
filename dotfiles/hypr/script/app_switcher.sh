#!/bin/bash
if pgrep -x wofi > /dev/null; then
    pkill -x wofi
    exit 0
fi

# --- util: escapar regex para Hyprland ---
regex_escape() {
  printf '%s' "$1" | sed 's/[][(){}.^$*+?|\\/]/\\&/g'
}

# Índices globales
declare -A WMCLASS2DESKTOP
declare -A EXEC2DESKTOP
declare -A NAME2DESKTOP
declare -A DESKTOP2ICON

# --- construir índice una vez ---
build_index() {
  local f line key val exe parts n

  for f in /usr/share/applications/*.desktop; do
    [ -f "$f" ] || continue
    local name_noext="$(basename "$f" .desktop)"
    NAME2DESKTOP["${name_noext,,}"]="$f"

    while IFS='=' read -r key val; do
      key="${key,,}"
      val="${val%%$'\r'}"
      val="${val##+([[:space:]])}"
      val="${val%%+([[:space:]])}"
      case "$key" in
        startupwmclass)
          [ -n "$val" ] && WMCLASS2DESKTOP["${val,,}"]="$f"
          ;;
        exec)
          exe="${val%% *}"
          exe="${exe%%\%*}"
          exe="${exe##*/}"
          [ -n "$exe" ] && EXEC2DESKTOP["${exe,,}"]="$f"
          ;;
        icon)
          [ -n "$val" ] && DESKTOP2ICON["$f"]="$val"
          ;;
      esac
    done < <(grep -E '^(StartupWMClass|Exec|Icon)=' "$f")
  done
}

# --- localizar .desktop ---
get_desktop_file() {
  local class="$1"
  local lc="${class,,}"
  local base="${lc%%-*}"
  local last="${lc##*.}"

  # 1) StartupWMClass exacto
  [ -n "${WMCLASS2DESKTOP[$lc]:-}" ] && { echo "${WMCLASS2DESKTOP[$lc]}"; return; }
  [ -n "${WMCLASS2DESKTOP[$last]:-}" ] && { echo "${WMCLASS2DESKTOP[$last]}"; return; }

  # 2) nombre exacto
  [ -n "${NAME2DESKTOP[$lc]:-}" ] && { echo "${NAME2DESKTOP[$lc]}"; return; }

  # 3) parcial en nombre
  for k in "${!NAME2DESKTOP[@]}"; do
    [[ "$k" == *"$lc"* ]] && { echo "${NAME2DESKTOP[$k]}"; return; }
  done

  # 4) ejecutable base
  [ -n "${EXEC2DESKTOP[$base]:-}" ] && { echo "${EXEC2DESKTOP[$base]}"; return; }
  [ -n "${EXEC2DESKTOP[$lc]:-}" ] && { echo "${EXEC2DESKTOP[$lc]}"; return; }
  [ -n "${EXEC2DESKTOP[$last]:-}" ] && { echo "${EXEC2DESKTOP[$last]}"; return; }

  echo ""
}

# --- icono: ruta o nombre ---
resolve_icon_path() {
  local desktop="$1" icon="$2"
  [ -z "$icon" ] && { echo ""; return; }

  # si es ruta absoluta
  [[ "$icon" = /* && -f "$icon" ]] && { echo "$icon"; return; }

  for ext in png svg xpm; do
    [ -f "/usr/share/pixmaps/$icon.$ext" ] && { echo "/usr/share/pixmaps/$icon.$ext"; return; }
    [ -f "/usr/share/icons/hicolor/48x48/apps/$icon.$ext" ] && { echo "/usr/share/icons/hicolor/48x48/apps/$icon.$ext"; return; }
  done

  local found
  found=$(find /usr/share/icons -type f \( -name "$icon.png" -o -name "$icon.svg" -o -name "$icon.xpm" \) -path "*/apps/*" -print -quit 2>/dev/null)
  [ -n "$found" ] && { echo "$found"; return; }

  echo "$icon"
}

# --- MAIN ---
build_index   # 🔴 solo una vez

active_class=$(hyprctl activewindow | grep -oP 'class:\s+\K\S+')
active_ws=$(hyprctl activewindow | grep -oP 'workspace:\s+\K\d+')

declare -A row2class row2icon
menu=""

ws=""; class=""; title=""
while IFS= read -r line; do
  if [[ "$line" =~ workspace:\ ([0-9]+) ]]; then
    ws="${BASH_REMATCH[1]}"
  elif [[ "$line" =~ class:\ (.+) ]]; then
    class="${BASH_REMATCH[1]}"
  elif [[ "$line" =~ title:\ (.+) ]]; then
    title="${BASH_REMATCH[1]}"

    row="[$ws] $class — $title"
    if [[ "$class" == "$active_class" && "$ws" == "$active_ws" ]]; then
      row="→ $row"
    fi

    row2class["$row"]="$class"

    desktop=$(get_desktop_file "$class")
    iconname="${DESKTOP2ICON[$desktop]:-}"
    row2icon["$row"]="$(resolve_icon_path "$desktop" "$iconname")"

    menu+="$row"$'\n'
    ws=""; class=""; title=""
  fi
done < <(hyprctl clients)

choice=$(echo "$menu" | wofi --dmenu -p "Ir a ventana:")
[ -z "$choice" ] && exit
class="${row2class[$choice]}"
ws=$(echo "$choice" | grep -oP '\[(\d+)\]' | tr -d '[]')
CONFIG="$HOME/.config/hypr/workspaces.conf"
WORKSPACE=$(grep "workspace = $ws" "$CONFIG" | awk -F'name: "' '{print $2}' | sed 's/".*//')


esc_class=$(regex_escape "$class")
hyprctl dispatch workspace "$ws"
hyprctl dispatch "focuswindow class:^${esc_class}$"

icon="${row2icon[$choice]}"
[ -n "$icon" ] && notify-send -u normal -i "$icon" "$ws :|: $WORKSPACE" "$class" || notify-send -u normal "$ws :|: $WORKSPACE" "$class"

