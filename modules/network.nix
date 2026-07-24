{ ... }:

{
  flake.modules.nixos.network = {
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;
    services.firewalld.enable = true;
    networking.nftables.enable = true;
    services.resolved.enable = true;
  };
}
