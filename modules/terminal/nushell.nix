{ ... }:

{
  flake.modules.homeManager.terminal = {
    programs.nushell = {
      enable = true;
      configFile.source = ../../dotfiles/nushell/config.nu;
    };
  };
}
