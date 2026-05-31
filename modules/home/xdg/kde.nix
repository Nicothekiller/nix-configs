{ lib, pkgs, ... }:

{
  # Dolphin relies on KDE's service cache for application discovery. Outside
  # Plasma, provide a minimal freedesktop menu and rebuild the cache after Home
  # Manager writes desktop entries.
  xdg.configFile."menus/applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
      "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
    <Menu>
      <Name>Applications</Name>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <Include>
        <All/>
      </Include>
    </Menu>
  '';

  xdg.configFile."dolphinrc".text = ''
    MenuBar=Disabled

    [General]
    Version=202

    [KFileDialog Settings]
    Places Icons Auto-resize=false
    Places Icons Static Size=22

    [MainWindow]
    MenuBar=Disabled

    [Notification Messages]
    warnAboutRisksBeforeActingAsAdmin=false

    [UiSettings]
    ColorScheme=DankMatugen
  '';

  # Hide Kitty's broad opener desktop file so it does not steal folders from
  # Dolphin in Open With/default application lists.
  xdg.dataFile."applications/kitty-open.desktop".text = ''
    [Desktop Entry]
    Hidden=true
    NoDisplay=true
    Type=Application
  '';

  # Use Kitty for external terminal launches. TerminalService is deleted because
  # KDE service lookup can be brittle under non-Plasma sessions; the command is
  # enough for Dolphin's external terminal actions.
  home.activation.updateKdeServiceCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
      --file kdeglobals --group General \
      --key TerminalApplication kitty
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
      --file kdeglobals --group General \
      --key TerminalService --delete
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
      --file kdeglobals --group Icons \
      --key Theme breeze-dark
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
      --file kcminputrc --group Mouse \
      --key cursorTheme breeze_cursors
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
      --file kcminputrc --group Mouse \
      --key cursorSize 24
    XDG_MENU_PREFIX= \
      ${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental
  '';
}
