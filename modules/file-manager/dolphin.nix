{ ... }:

{
  flake.modules.homeManager.file-manager = { lib, pkgs, ... }: {
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

    qt.kde.settings = {
      "kdeglobals".General.TerminalApplication = "kitty";
      "kdeglobals".General.TerminalService = null;
      "kdeglobals".UiSettings.ColorScheme = "DankMatugen";
      "kdeglobals".Icons.Theme = "breeze-dark";
      "kcminputrc".Mouse.cursorTheme = "breeze_cursors";
      "kcminputrc".Mouse.cursorSize = 24;
    };

    home.activation.updateKdeServiceCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      XDG_MENU_PREFIX= \
        ${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental
    '';
  };
}
