{ ... }:

{
  flake.modules.nixos.desktop-services = {
    programs.kdeconnect.enable = true;
    services.flatpak.enable = true;
  };
}
