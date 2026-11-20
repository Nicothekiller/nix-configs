{ inputs, ... }:

{
  flake.modules.nixos.applications = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      appimage-run
      firewalld-gui
      haruna
      vesktop
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
