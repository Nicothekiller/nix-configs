{ ... }:

{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      corefonts
      ipafont
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      vista-fonts
    ];

    fonts.fontDir.enable = true;
  };
}
