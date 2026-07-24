{ inputs, ... }:

let
  system = "x86_64-linux";

  unstableOverlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
    };
  };

  flatpakFontFixOverlay = final: prev: {
    flatpak = prev.flatpak.overrideAttrs (old: {
      patches = builtins.map (
        patch:
        if builtins.baseNameOf patch == "fix-fonts-icons.patch" then
          ../modules/patches/fix-fonts-icons.patch
        else
          patch
      ) (old.patches or [ ]);
    });
  };
in
{
  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [
      unstableOverlay
      flatpakFontFixOverlay
    ];
  };
}
