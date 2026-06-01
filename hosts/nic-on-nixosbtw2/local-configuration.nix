{ pkgs, ... }:
{
  networking.hostName = "nic-on-nixosbtw2";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libva-vdpau-driver
  ];

  fileSystems."/".options = [ "compress=lzo" ];

  home-manager.users.nic.home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };
}
