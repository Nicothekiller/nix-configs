{ ... }:

{
  flake.modules.nixos.desktop-theme = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      hicolor-icon-theme
      kdePackages.kconfig
      kdePackages.kservice
      kdePackages.qt6ct
      libsForQt5.qt5ct
    ];
  };
}
