{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [ "https://yuuhikaze.cachix.org" ];
    trusted-public-keys = [ "yuuhikaze.cachix.org-1:AtGF4hsoNZahll0Ew3U8fH1CpzKl+OJFPM1tw9qNsYo=" ];

    trusted-users = [
      "root"
      "nic"
    ];
  };

  programs.nix-ld.enable = true;
}
