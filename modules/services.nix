{ config, pkgs, ... }:

{
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # programs.ssh = {
  #   # for using the kde ssh handler
  #   # askPassword = "ksshaskpass";
  #   # enableAskPassword = true;
  #
  #   startAgent = true;
  # };

  # for using the kde ssh handler
  # environment.sessionVariables = {
  #   SSH_ASKPASS_REQUIRE = "prefer";
  # };

  hardware.bluetooth.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ epson-escpr ];
  };
}
