{ ... }:

let
  shellAliases = {
    neofetch = "fastfetch --config neofetch";
    cp = "cp -i";
    mv = "mv -i";
    mkdir = "mkdir -p";
    ps = "ps auxf";
    less = "less -R";
    cls = "clear";
    ls = "ls -aFh --color=always";
    lr = "ls -lRh";
    ip = "ip -color";
    lg = "lazygit";
    cat = "bat";
  };
in
{
  flake.modules.homeManager.terminal = {
    programs.zsh.shellAliases = shellAliases;
    programs.bash.shellAliases = shellAliases;
  };
}
