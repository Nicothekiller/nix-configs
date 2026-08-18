{ ... }:
{
  flake.modules.nixos.redes-course-deps = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      containerlab
      wireshark
      cisco-packet-tracer
    ];

    users.users.nic.extraGroups = [
      "wireshark"
    ];
  };
}
