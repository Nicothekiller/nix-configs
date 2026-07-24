{ ... }:

{
  flake.modules.nixos.gaming = { pkgs, ... }: {
    programs.steam.enable = true;
    programs.steam.extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
  };
}
