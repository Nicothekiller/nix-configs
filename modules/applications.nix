{ ... }:

{
  flake.modules.nixos.applications = { pkgs, ... }: {
    nixpkgs.config.permittedInsecurePackages = [ "pnpm-10.29.2" ];

    environment.systemPackages = with pkgs; [
      appimage-run
      firewalld-gui
      haruna
      vesktop
    ];
  };
}
