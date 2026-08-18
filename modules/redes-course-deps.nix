{ ... }:
{
  flake.modules.nixos.redes-course-deps = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      containerlab
      wireshark
      cisco-packet-tracer
    ];

    programs.wireshark.enable = true;

    users.users.nic.extraGroups = [
      "wireshark"
    ];
  };
}
