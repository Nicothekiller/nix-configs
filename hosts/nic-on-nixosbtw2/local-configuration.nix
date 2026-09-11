{ pkgs, ... }:
{
  networking.hostName = "nic-on-nixosbtw2";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  # PRIME offload: Intel drives the laptop panel, NVIDIA renders on
  # demand. allowExternalGpu enables reverse PRIME so the HDMI port
  # wired to the dGPU keeps working.
  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    allowExternalGpu = true;
    intelBusId = "PCI:0:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libva-vdpau-driver
  ];

  fileSystems."/".options = [ "compress=lzo" ];

  home-manager.users.nic.home.sessionVariables = {
    HYPR_MONITOR_SCALE = "1.25";
    WLR_NO_HARDWARE_CURSORS = "1";
    GBM_BACKEND = "nvidia-drm";
    # Intel video decode to match intel-media-driver above.
    LIBVA_DRIVER_NAME = "iHD";
  };
}
