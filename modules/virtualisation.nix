{ ... }:

{
  flake.modules.nixos.virtualisation = { pkgs, ... }: {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
    };

    users.users.nic.extraGroups = [
      "podman"
      "docker"
    ];
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
