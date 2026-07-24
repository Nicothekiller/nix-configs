{ ... }:

{
  flake.modules.nixos.users = { pkgs, ... }: {
    users.users.nic = {
      isNormalUser = true;
      description = "nic";
      createHome = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "dialout"
      ];
      shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
  };
}
