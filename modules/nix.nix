{ ... }:

{
  flake.modules.nixos.nix = {
    nixpkgs.config.allowUnfree = true;
    nix = {
      # Replaced by programs.nh clean (keeps N generations + time window,
      # which nix.gc cannot express). Kept for reference.
      # gc = {
      #   automatic = true;
      #   dates = "daily";
      #   options = "--delete-older-than 7d";
      # };
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [ "https://yuuhikaze.cachix.org" ];
        trusted-public-keys = [
          "yuuhikaze.cachix.org-1:AtGF4hsoNZahll0Ew3U8fH1CpzKl+OJFPM1tw9qNsYo="
        ];
        trusted-users = [
          "root"
          "nic"
        ];
      };
    };
    programs.nix-ld.enable = true;
    programs.nh = {
      enable = true;
      flake = "/etc/nixos";
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 5";
    };
  };
}
