{ ... }:

{
  flake.modules.nixos.virtualisation = { pkgs, ... }: {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
    };

    users.users.nic.extraGroups = [
      "docker"
    ];
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
