{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      unstableOverlay = final: prev: {
        unstable = import nixpkgs-unstable { inherit system; };
      };
    in
    {
      nixosConfigurations = {
        nic-on-nixosbtw = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [ unstableOverlay ];
            }
            ./configuration.nix
            ./hosts/nic-on-nixosbtw/hardware-configuration.nix
            ./hosts/nic-on-nixosbtw/local-configuration.nix
          ];
        };
        nic-on-nixosbtw2 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [ unstableOverlay ];
            }
            ./configuration.nix
            ./hosts/nic-on-nixosbtw2/hardware-configuration.nix
            ./hosts/nic-on-nixosbtw2/local-configuration.nix
          ];
        };
      };
    };
}
