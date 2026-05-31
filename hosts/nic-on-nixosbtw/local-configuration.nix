{ pkgs, ... }:
{
  networking.hostName = "nic-on-nixosbtw";

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];
}
