{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core CLI and development tools.
    pkgs.unstable.neovim
    bat
    btop
    clang
    fd
    gh
    git
    lazydocker
    lazygit
    nixfmt
    python3
    ripgrep
    rustup
    sqlite
    tree-sitter
    wget

    # Archive and removable-media helpers used by Dolphin/UDisks.
    dosfstools
    exfatprogs
    ntfs3g
    unzip

    # KDE apps and KIO helpers for Dolphin outside a full Plasma session.
    kdePackages.ark
    kdePackages.breeze
    kdePackages.breeze-gtk
    kdePackages.breeze-icons
    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.kio-admin
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.konsole
    kdePackages.okular

    # Qt/KDE configuration utilities used by Home Manager activation hooks.
    libsForQt5.qt5ct
    kdePackages.kconfig
    kdePackages.kservice
    kdePackages.qt6ct

    # Icon fallbacks for incomplete application icon themes.
    adwaita-icon-theme
    hicolor-icon-theme

    # Desktop apps and runtime wrappers.
    appimage-run
    firewalld-gui
    vesktop
  ];

  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontDir.enable = true;

  programs.steam.enable = true;

  services.flatpak.enable = true;

  programs.steam.extraCompatPackages = [
    pkgs.unstable.proton-ge-bin
  ];

  programs.kdeconnect.enable = true;
}
