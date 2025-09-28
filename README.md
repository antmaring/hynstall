# INSTALL
Clonar repositorio con git clone https://github.com/antmaring/hynstall.git...
Entrar en el directorio hynstall... 
Lanzar desde la terminal ./hinstall.sh...
Si todo ha ido bien, cierra la sesión para volver a la pantalla de autenticación.
Seleccionar Hyprland desde la pantalla de autenticación y continuar para entrar en el nuevo Window Manager.

#ATAJOS
Con SUPER+ENTER, abres terminal.
Con SUPER+CONTROL+End, apagas el sistema.
Con SUPER+SHIFT+End, reinicias el sistema.
Con ALT+SHIFT+End, cierras la sesión para volver a la pantalla de autenticación.
Con SUPER+C, abres Chromium.
Con SUPER+F, abres Firefox.

#SOBRE Hyprland
Mira .config/hypr/keybindings para ver los programas que están configurados en los atajos. Y añade los que quieras.
Mira .config/hypr/windowrules para ver los workspaces donde se alojarán los programas (si no viene referencia el programa se abre donde se lanzó).
Mira Wallpapers/hypr para ver los wallpapers entre los cuales se alterna. Elimina o añade como quieras.
Abre wev y pulsa tecla que quieres verificar para ver el class y poder añadir programa nuevo en windowrules.
Lanza desde la consola hyprctl clients para ver detalles: monitor, nombre del programa, etc.
Lanza desde la consola hyprctl monitors para ver monitores detectados. Como sólo tendrás uno, da igual. Pero si tienes varios, puedes modificar .config/hypr/env.conf para dirigir donde quieras.
