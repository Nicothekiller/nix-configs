{ inputs, ... }:

let
  flatpakFontFixOverlay = final: prev: {
    flatpak = prev.flatpak.overrideAttrs (
      old:
      let
        original = old.patches or [ ];
        replaced = builtins.map (
          patch:
          if builtins.baseNameOf patch == "fix-fonts-icons.patch" then
            ./patches/fix-fonts-icons.patch
          else
            patch
        ) original;
        matched = builtins.filter (patch: builtins.baseNameOf patch == "fix-fonts-icons.patch") original;
      in
      {
        # Upstream PR to fix Flatpak fonts/icons has sat unreviewed for
        # months, so the local patch stays. Fail loudly instead of silently
        # no-opping if nixpkgs renames, removes, or merges the patch.
        # NOTE: the check lives inside the patches value, not in the branch
        # selection of the override body -- forcing old.patches while the
        # body is still computing args recurses infinitely.
        patches =
          if builtins.length matched == 0 then
            throw ''
              flatpak overlay: fix-fonts-icons.patch not found in nixpkgs
              flatpak patches. Upstream may have renamed, removed, or merged
              it. Update modules/patches/fix-fonts-icons.patch and
              modules/overlays.nix.
            ''
          else
            replaced;
      }
    );
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
      flatpakFontFixOverlay
      ciscoPacketTracerOverlay
    ];
  };
}
