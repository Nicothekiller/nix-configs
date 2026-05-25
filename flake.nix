{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
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

            home-manager.nixosModules.home-manager
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

            home-manager.nixosModules.home-manager
            ./configuration.nix
            ./hosts/nic-on-nixosbtw2/hardware-configuration.nix
            ./hosts/nic-on-nixosbtw2/local-configuration.nix
          ];
        };
      };
    };
}
