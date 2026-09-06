{ ... }:

{
  flake.modules.nixos.printing = { pkgs, ... }: {
    services.printing = {
      enable = true;
      startWhenNeeded = true;
      drivers = [ pkgs.epson-escpr ];
    };
  };
}
