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

  ciscoPacketTracerOverlay = final: prev: {
    cisco-packet-tracer = final.callPackage ../packages/cisco-packet-tracer.nix {
      version = "9.0.1";
      src = builtins.path {
        path = inputs.cisco-packet-tracer-deb;
        name = "CiscoPacketTracer_901_Ubuntu_64bit.deb";
      };
    };
  };
in
{
  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [
      unstableOverlay
      flatpakFontFixOverlay
      ciscoPacketTracerOverlay
    ];
  };
}
