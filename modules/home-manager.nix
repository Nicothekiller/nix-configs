{ self, ... }:

{
  flake.modules.nixos.home-manager = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.nic = {
      imports = builtins.attrValues self.modules.homeManager;

      home.username = "nic";
      home.homeDirectory = "/home/nic";
      home.stateVersion = "26.05";

      programs.git = {
        enable = true;
        settings.user = {
          name = "Nicothekiller";
          email = "nicolasnaran@gmail.com";
        };
      };
    };
  };
}
