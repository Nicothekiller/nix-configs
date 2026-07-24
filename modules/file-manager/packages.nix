{ ... }:

{
  flake.modules.nixos.file-manager = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      dosfstools
      exfatprogs
      ntfs3g
      unzip
      kdePackages.ark
      kdePackages.breeze
      kdePackages.breeze-gtk
      kdePackages.breeze-icons
      kdePackages.dolphin
      kdePackages.gwenview
      kdePackages.kio
      kdePackages.kio-admin
      kdePackages.kio-extras
      kdePackages.kio-fuse
      kdePackages.konsole
      kdePackages.kcalc
      kdePackages.okular
    ];
  };
}
