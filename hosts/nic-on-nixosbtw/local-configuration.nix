{ pkgs, kernelPackages, ... }:
{
  networking.hostName = "nic-on-nixosbtw";

  # Pinned kernel 6.18.57, see flake.nix for why.
  boot.kernelPackages = kernelPackages;

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];

  home-manager.users.nic.home.sessionVariables = {
    HYPR_MONITOR_SCALE = "1";
  };
}
