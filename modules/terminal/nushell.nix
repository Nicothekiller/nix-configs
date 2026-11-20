{ ... }:

{
  flake.modules.homeManager.terminal = {
    programs.nushell = {
      enable = true;
      loadSessionVariables = true;
      configFile.source = ../../dotfiles/nushell/config.nu;
    };
  };
}
