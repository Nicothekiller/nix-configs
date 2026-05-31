{ pkgs, ... }:

{
  # Breeze ships its cursor theme as "breeze_cursors". Hyprland falls back to
  # its default cursor if this does not match the real icon directory name.
  home.pointerCursor = {
    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
