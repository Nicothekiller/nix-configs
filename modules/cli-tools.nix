{ ... }:

{
  flake.modules.nixos.cli-tools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      unstable.neovim
      bat
      btop
      clang
      fd
      gh
      git
      gnumake
      lazydocker
      lazygit
      nixfmt
      python3
      ripgrep
      rustup
      sqlite
      tree-sitter
      wget
    ];
  };
}
