{ ... }:

{
  flake.modules.nixos.hyprland = { pkgs, ... }: {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      systemd.target = "hyprland-session.target";
      recommendedServices.enable = true;
    };
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        # Use Hyprland UWSM session by default; Name from hyprland-uwsm.desktop
        session.default = "Hyprland (uwsm-managed)";
        # Keep greeter in sync style; palette/wallpaper will be synced from desktop via Settings → Security → Sync Now
        appearance.scheme = "Synced";
      };
      cursorTheme = {
        package = pkgs.kdePackages.breeze;
        name = "breeze_cursors";
      };
    };
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };

  flake.modules.homeManager.hyprland = { ... }: {
    xdg.configFile."hypr/hyprland.lua".source = ../dotfiles/hypr/hyprland.lua;
    xdg.configFile."hypr/binds.lua".source = ../dotfiles/hypr/binds.lua;
    xdg.configFile."hypr/windowrules.lua".source = ../dotfiles/hypr/windowrules.lua;

    xdg.configFile."noctalia/config.toml".source = ../dotfiles/noctalia/config.toml;

    xdg.configFile."wallpapers" = {
      source = ../dotfiles/backgrounds;
      recursive = true;
    };
  };
}
