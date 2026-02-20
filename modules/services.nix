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
  programs.ssh = {
    askPassword = "ksshaskpass";
    enableAskPassword = true;
  };

  environment.sessionVariables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  hardware.bluetooth.enable = true;
}
