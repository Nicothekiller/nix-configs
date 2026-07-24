{ ... }:

{
  flake.modules.homeManager.desktop-theme =
    { config, ... }:
    let
      qtctAppearance = {
        style = "Breeze";
        icon_theme = "breeze-dark";
        color_scheme_path = "/home/nic/.config/qt6ct/colors/matugen.conf";
        custom_palette = true;
      };
    in
    {
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "breeze";
        qt5ctSettings.Appearance = qtctAppearance;
        qt6ctSettings.Appearance = qtctAppearance;
      };

      home.sessionVariables.QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";

      xdg.configFile."qt5ct/colors/matugen.conf".source =
        config.lib.file.mkOutOfStoreSymlink "/home/nic/.config/qt6ct/colors/matugen.conf";
    };
}
