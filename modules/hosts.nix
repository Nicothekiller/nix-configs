{ inputs, self, ... }:

let
  sharedModules = builtins.attrValues self.modules.nixos;
in
{
  flake.nixosConfigurations.nic-on-nixosbtw = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = sharedModules ++ [
      inputs.home-manager.nixosModules.home-manager
      ../hosts/nic-on-nixosbtw/hardware-configuration.nix
      ../hosts/nic-on-nixosbtw/local-configuration.nix
    ];
  };

  flake.nixosConfigurations.nic-on-nixosbtw2 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = sharedModules ++ [
      inputs.home-manager.nixosModules.home-manager
      ../hosts/nic-on-nixosbtw2/hardware-configuration.nix
      ../hosts/nic-on-nixosbtw2/local-configuration.nix
    ];
  };
}
