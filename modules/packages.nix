{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pkgs.unstable.neovim
    fastfetch
    kitty
    nushell
    chezmoi
    gh
    git
    zoxide
    starship
    carapace
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
    flutter
    jdk
    distrobox
    lazydocker
    pkgs.unstable.opencode
    rustup
  ];

  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontDir.enable = true;

  programs.steam.enable = true;

  services.flatpak.enable = true;
}
