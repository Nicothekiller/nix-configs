{ pkgs, ... }:
{
  networking.hostName = "nic-on-nixosbtw2";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libva-vdpau-driver
  ];

  fileSystems."/".options = [ "compress=lzo" ];
}
