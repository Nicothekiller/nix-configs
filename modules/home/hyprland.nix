{ config, ... }:

{
  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/hypr/hyprland.lua";
}
