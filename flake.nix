{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Kernel 6.18.57 for nic-on-nixosbtw only: newer kernels hang on suspend
    # on that machine. Pinned by rev from flake-lock commit 761d843. Only the
    # kernel comes from here, userspace stays on the nixpkgs input above.
    # Bump this rev deliberately; `nix flake update` does not touch it.
    nixpkgs-kernel = {
      url = "github:NixOS/nixpkgs/02c087f3fe673c9e317f206a627cb6b910336dbe";
      flake = false;
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cisco-packet-tracer-deb = {
      url = "path:/home/nic/Downloads/CiscoPacketTracer_901_Ubuntu_64bit.deb";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];
    };
}
