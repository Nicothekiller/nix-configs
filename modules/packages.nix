{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pkgs.unstable.neovim

    # disabled because of home manager
    # fastfetch
    # kitty
    # nushell
    # chezmoi

    # zoxide
    # starship
    # carapace

    gh
    git

    bat
    python3
    unzip
    wget
    tree-sitter
    lazygit
    ripgrep
    fd
    sqlite
    clang
    firewalld-gui
    btop
    nixfmt
    # jdk
    lazydocker

    # handled in home.nix
    # pkgs.unstable.opencode

    rustup
    appimage-run
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
}
