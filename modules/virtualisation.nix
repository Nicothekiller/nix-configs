{ ... }:

{
  flake.modules.nixos.virtualisation = { pkgs, ... }: {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      containers.registries.search = [ "docker.io" ];
    };

    users.users.nic.extraGroups = [
      "podman"
      "docker"
    ];
    environment.systemPackages = with pkgs; [
      docker-compose
      podman-compose
    ];
  };
}
