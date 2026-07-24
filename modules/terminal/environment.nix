{ ... }:

{
  flake.modules.homeManager.terminal = {
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      CC = "clang";
      CXX = "clang++";
    };

    home.sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "/var/lib/flatpak/exports/bin"
      "/.local/share/flatpak/exports/bin"
    ];
  };
}
