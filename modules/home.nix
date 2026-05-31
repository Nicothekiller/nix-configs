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
        ./home/kitty.nix
        ./home/hyprland.nix
        ./home/xdg.nix
      ];

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
