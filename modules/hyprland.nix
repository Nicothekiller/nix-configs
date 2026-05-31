{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
  };

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "hyprland";
    configHome = "/home/nic";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";
  environment.sessionVariables.QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
  environment.sessionVariables.XCURSOR_THEME = "breeze_cursors";
  environment.sessionVariables.XDG_MENU_PREFIX = "";
}
