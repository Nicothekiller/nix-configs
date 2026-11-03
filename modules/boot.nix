{ lib, ... }:

{
  flake.modules.nixos.boot = { pkgs, ... }: {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # Default for hosts that do not pin their own kernel, see flake.nix.
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
  };
}
