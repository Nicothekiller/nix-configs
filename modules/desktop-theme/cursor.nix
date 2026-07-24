{ ... }:

{
  flake.modules.homeManager.desktop-theme = { pkgs, ... }: {
    home.pointerCursor = {
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
