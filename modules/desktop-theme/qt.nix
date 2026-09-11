{ ... }:

{
  flake.modules.homeManager.desktop-theme = { ... }: {
    # Bare qtct platform so Noctalia's Qt/KColorScheme templates have
    # something to latch onto (select the "noctalia" scheme in qt6ct).
    # No DMS matugen custom palette wiring — Noctalia owns Qt theming now.
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "breeze";
    };

    home.sessionVariables.QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
  };
}
