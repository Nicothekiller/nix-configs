{ ... }:

{
  flake.modules.nixos.applications = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      appimage-run
      firewalld-gui
      haruna
      vesktop
    ];
  };
}
