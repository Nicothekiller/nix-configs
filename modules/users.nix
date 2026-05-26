{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.nic = {
    isNormalUser = true;
    description = "nic";
    createHome = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"
    ];
    shell = pkgs.zsh;

    # packages = with pkgs; [ ];
  };

  # needed for default shell
  programs.zsh.enable = true;
}
