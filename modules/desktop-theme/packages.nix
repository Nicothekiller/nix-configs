{ ... }:

{
  flake.modules.nixos.desktop-theme = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      adw-gtk3
      glib
      hicolor-icon-theme
      kdePackages.kconfig
      kdePackages.kservice
      kdePackages.qt6ct
      libsForQt5.qt5ct
    ];
  };
}
