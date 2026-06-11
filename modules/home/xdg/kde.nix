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

  # Use the declarative qt.kde.settings module which wraps kwriteconfig6 calls
  # in the activation script and sends DBus reload signals to KWin/KGlobalSettings.
  qt.kde.settings = {
    "kdeglobals".General.TerminalApplication = "kitty";
    "kdeglobals".General.TerminalService = null;
    "kdeglobals".UiSettings.ColorScheme = "DankMatugen";
    "kdeglobals".Icons.Theme = "breeze-dark";
    "kcminputrc".Mouse.cursorTheme = "breeze_cursors";
    "kcminputrc".Mouse.cursorSize = 24;
  };

  # kbuildsycoca6 is not covered by qt.kde.settings; rebuild the KDE service
  # cache so Dolphin discovers applications correctly.
  home.activation.updateKdeServiceCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    XDG_MENU_PREFIX= \
      ${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental
  '';
}
