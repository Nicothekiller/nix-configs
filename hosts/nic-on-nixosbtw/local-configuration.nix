{ pkgs, ... }:
{
  networking.hostName = "nic-on-nixosbtw";

  # Testing latest stable kernel for the suspend freeze, which also hit
  # the previously pinned 6.18.57. Pin kept in flake.nix as fallback.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];

  home-manager.users.nic.home.sessionVariables = {
    HYPR_MONITOR_SCALE = "1";
  };
}
