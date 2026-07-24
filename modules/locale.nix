{ ... }:

{
  flake.modules.nixos.locale = {
    time.timeZone = "America/Guayaquil";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "es_EC.UTF-8";
      LC_IDENTIFICATION = "es_EC.UTF-8";
      LC_MEASUREMENT = "es_EC.UTF-8";
      LC_MONETARY = "es_EC.UTF-8";
      LC_NAME = "es_EC.UTF-8";
      LC_NUMERIC = "es_EC.UTF-8";
      LC_PAPER = "es_EC.UTF-8";
      LC_TELEPHONE = "es_EC.UTF-8";
      LC_TIME = "es_EC.UTF-8";
    };
    services.xserver.xkb = {
      layout = "latam";
      variant = "";
    };
    console.keyMap = "la-latin1";
  };
}
