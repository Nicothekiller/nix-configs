{ ... }:

{
  flake.modules.nixos.system-state = {
    system.stateVersion = "25.11";
  };
}
