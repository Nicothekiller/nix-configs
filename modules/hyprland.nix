{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.dms-shell = {
    package = pkgs.unstable.dms-shell;
    enable = true;
    systemd.enable = true;
  };

  services.displayManager.dms-greeter = {
    package = pkgs.unstable.dms-shell;
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
}
