#!/usr/bin/env bash

# ----------------------------
# Instalador de Hyprland + dotfiles desde GitHub
# ----------------------------

#REPO_URL="https://github.com/usuario/mis-dotfiles.git"
CONFIG_DIR="$HOME/.config"
WALLPAPERS_DIR="$HOME/Wallpapers"

# Paquetes principales (pacman)
#  sudo pacman -S 
 #sudo pacman -S hyprpaper wofi
pacman_apps=(
  "hyprland"
  "xdg-desktop-portal-hyprland"
  "swaync"
  "swww"
  "swaylock"
  "waybar"
  "bemenu"
  "slurp"
  "grim"
  "wev"
  "nwg-look"
  "rofi"
  "foot"
  "alacritty"
  "sakura"
  "wezterm"
  "ranger"
  "vifm"
  "yazi"
  "mpv"
  "pipewire" 
  "pipewire-alsa" 
  "pipewire-jack" 
  "pipewire-pulse" 
  "pipewire-audio" 
  "wireplumber"
)

# Paquetes AUR (yay)
aur_apps=(
  "bibata-cursor-theme"
  "catppuccin-gtk-theme-mocha"
)

# ----------------------------
# Funciones
# ----------------------------

is_installed() {
  pacman -Qi "$1" &>/dev/null || yay -Qi "$1" &>/dev/null
}

xinstall_apps_pacman() {
  echo "🔧 Instalando paquetes con pacman..."
  for app in "${pacman_apps[@]}"; do
   if is_installed "$app"; then
     echo "✅ $app ya está instalado."
   else
     echo "📦 Instalando $app con pacman..."
     sudo pacman -S --noconfirm --needed "$app"
   fi
  done
}

xinstall_apps_aur() {
  echo "🛠️ Instalando paquetes con yay..."
  for app in "${aur_apps[@]}"; do
    if is_installed "$app"; then
      echo "✅ $app ya está instalado."
    else
      echo "📦 Instalando $app con yay..."
      yay -S --noconfirm --needed "$app"
    fi
  done
}

install_apps_pacman() {
  echo "🔧 Instalando paquetes con pacman..."
  for app in "${pacman_apps[@]}"; do
    echo "📦 Instalando $app con pacman..."
    sudo pacman -S --noconfirm --needed "$app"
  done
  systemctl --user enable pipewire pipewire-pulse wireplumber
}

install_apps_aur() {
  echo "🛠️ Instalando paquetes con yay..."
  for app in "${aur_apps[@]}"; do
    echo "📦 Instalando $app con yay..."
    yay -S --noconfirm --needed "$app"
  done
}

install_dotfiles() {
  mkdir -p "$CONFIG_DIR"
  echo "📂 Copiando dotfiles a $CONFIG_DIR..."
  find ./dotfiles -type d | while read -r f; do
    target="$CONFIG_DIR/$(basename "$f")"
    [ -L "$target" ] && rm -rf "$target"
  done
  #rsync -avh --ignore-existing "./dotfiles/" "$CONFIG_DIR/"
  rsync -avh "./dotfiles/" "$CONFIG_DIR/"
}

install_wallpapers() {
  mkdir -p $WALLPAPERS_DIR
  echo "📂 Copiando wallpapers a $WALLPAPERS_DIR..."
  mkdir -p "$CONFIG_DIR"
  rsync -avh --ignore-existing "./wallpapers/" "$WALLPAPERS_DIR/"
}


# ----------------------------
# Preparar
# ----------------------------
#echo "📥 Clonando repositorio desde $REPO_URL..."
#rm -rf "$TMP_DIR"
#git clone --depth=1 "$REPO_URL" "$TMP_DIR"

# ----------------------------
# Instalar paquetes pacman
# ----------------------------
install_apps_pacman

# ----------------------------
# Instalar paquetes AUR
# ----------------------------
install_apps_aur

# ----------------------------
# Copiar dotfiles
# ----------------------------
install_dotfiles

# ----------------------------
# Copiar wallpapers
# ----------------------------
install_wallpapers

echo "✨ Instalación y configuración completada."
