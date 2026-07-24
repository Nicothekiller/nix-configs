{ ... }:

{
  flake.modules.homeManager.desktop-theme = { pkgs, ... }: {
    gtk = {
      enable = true;
      theme = {
        name = "Breeze-Dark";
        package = pkgs.kdePackages.breeze-gtk;
      };
      iconTheme = {
        name = "breeze-dark";
        package = pkgs.kdePackages.breeze-icons;
      };
      font = {
        name = "Noto Sans";
        size = 10;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    };

    xdg.configFile."gtk-3.0/gtk.css".text = ''
      @import url("dank-colors.css");

      @define-color theme_bg_color_breeze @window_bg_color;
      @define-color theme_fg_color_breeze @window_fg_color;
      @define-color theme_base_color_breeze @view_bg_color;
      @define-color theme_text_color_breeze @view_fg_color;
      @define-color theme_selected_bg_color_breeze @accent_bg_color;
      @define-color theme_selected_fg_color_breeze @accent_fg_color;
      @define-color theme_unfocused_bg_color_breeze @window_bg_color;
      @define-color theme_unfocused_fg_color_breeze @window_fg_color;
    '';

    xdg.configFile."gtk-4.0/gtk.css".text = ''
      @import url("dank-colors.css");
      @import url("colors.css");
    '';
  };
}
