{ pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.nic = { config, pkgs, lib, ... }: {
      imports = [
        ./home/shell.nix
        ./home/opencode.nix
        ./home/starship.nix
        ./home/fastfetch.nix
        ./home/kitty.nix
        ./home/hyprland.nix
        ./home/xdg.nix
        ./home/xdg/gtk.nix
      ];

      home.username = "nic";
      home.homeDirectory = "/home/nic";

      home.stateVersion = "26.05";

      # Copy system fonts to ~/.local/share/fonts so flatpak apps can find them.
      # Flatpak automatically mounts ~/.local/share/fonts into the sandbox.
      home.activation.copySystemFonts = lib.hm.dag.entryAfter ["linkGeneration"] ''
        mkdir -p ~/.local/share/fonts
        cp -L /run/current-system/sw/share/X11/fonts/* ~/.local/share/fonts/
        ${pkgs.fontconfig}/bin/fc-cache -fv
      '';

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
