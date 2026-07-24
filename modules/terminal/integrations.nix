{ ... }:

{
  flake.modules.homeManager.terminal = {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };

    programs.carapace.enable = true;
  };
}
