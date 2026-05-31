{ ... }:

{
  programs.kitty.enable = true;

  xdg.configFile."kitty/kitty.conf".source = ../../dotfiles/kitty/kitty.conf;
  xdg.configFile."kitty/Darkside.conf".source = ../../dotfiles/kitty/Darkside.conf;
}
