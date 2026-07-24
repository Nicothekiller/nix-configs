{ ... }:

{
  flake.modules.nixos.desktop-services-system = {
    hardware.bluetooth.enable = true;
    security.polkit.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;
  };
}
