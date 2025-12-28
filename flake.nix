{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      nic-on-nixosbtw = nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ./hosts/nic-on-nixosbtw/hardware-configuration.nix ];
      };
      nic-on-nixosbtw2 = nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ./hosts/nic-on-nixosbtw2/hardware-configuration.nix ];
      };
    };
  };
}
