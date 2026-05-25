{ pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.nic = {
      imports = [
        ./home/shell.nix
        ./home/opencode.nix
        ./home/starship.nix
        ./home/fastfetch.nix
      ];

      home.username = "nic";
      home.homeDirectory = "/home/nic";

      home.stateVersion = "25.11";

      xdg.configFile."kitty".source = ../dotfiles/kitty;

      programs.kitty.enable = true;

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
