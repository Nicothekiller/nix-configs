{ ... }:

{
  flake.modules.nixos.bootvine = { pkgs, ... }: {
    services.bootvine.enable = true;
  };
}
