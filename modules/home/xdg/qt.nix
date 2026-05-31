{ config, ... }:

{
  # DMS generates a matugen palette for qt6ct. Qt5 apps get the same colors via
  # a symlink so both Qt generations follow the same wallpaper-derived theme.
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    icon_theme=breeze-dark
    color_scheme_path=/home/nic/.config/qt6ct/colors/matugen.conf
    custom_palette=true
  '';

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    icon_theme=breeze-dark
    color_scheme_path=/home/nic/.config/qt5ct/colors/matugen.conf
    custom_palette=true
  '';

  xdg.configFile."qt5ct/colors/matugen.conf".source =
    config.lib.file.mkOutOfStoreSymlink "/home/nic/.config/qt6ct/colors/matugen.conf";
}
