{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
      flatpakFontFixOverlay = final: prev: {
        flatpak = prev.flatpak.overrideAttrs (old: {
          patches = builtins.map (
            p:
            if builtins.baseNameOf p == "fix-fonts-icons.patch" then
              ./modules/patches/fix-fonts-icons.patch
            else
              p
          ) (old.patches or [ ]);
        });
      };
    in
    {
      nixosConfigurations = {
        nic-on-nixosbtw = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [
                unstableOverlay
                flatpakFontFixOverlay
              ];
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
              nixpkgs.overlays = [
                unstableOverlay
                flatpakFontFixOverlay
              ];
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
