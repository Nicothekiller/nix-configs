{ ... }:
{
  flake.modules.nixos.redes-course-deps = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      pkgs.unstable.containerlab
      wireshark
      cisco-packet-tracer
    ];

    programs.wireshark.enable = true;

    users.users.nic.extraGroups = [
      "wireshark"
    ];
  };
}
