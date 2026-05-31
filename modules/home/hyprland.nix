{ config, ... }:

{
  xdg.configFile."hypr/hyprland.conf".source =
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/hypr/hyprland.conf";
}
