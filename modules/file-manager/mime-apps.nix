{ ... }:

{
  flake.modules.homeManager.file-manager =
    { ... }:
    let
      gwenview = [ "org.kde.gwenview.desktop" ];
      helium = [ "helium.desktop" ];
      neovim = [ "nvim.desktop" ];
      okular = [ "okularApplication_pdf.desktop" ];
      dolphin = [ "org.kde.dolphin.desktop" ];
    in
    {
      xdg.dataFile."applications/kitty-open.desktop".text = ''
        [Desktop Entry]
        Hidden=true
        NoDisplay=true
        Type=Application
      '';

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = okular;
          "application/xhtml+xml" = helium;
          "inode/directory" = dolphin;
          "image/bmp" = gwenview;
          "image/gif" = gwenview;
          "image/jpeg" = gwenview;
          "image/png" = gwenview;
          "image/svg+xml" = gwenview;
          "image/tiff" = gwenview;
          "image/webp" = gwenview;
          "text/html" = helium;
          "text/plain" = neovim;
          "x-scheme-handler/http" = helium;
          "x-scheme-handler/https" = helium;
        };
        associations = {
          added = {
            "application/pdf" = okular;
            "application/xhtml+xml" = helium;
            "inode/directory" = dolphin;
            "image/bmp" = gwenview;
            "image/gif" = gwenview;
            "image/jpeg" = gwenview;
            "image/png" = gwenview;
            "image/svg+xml" = gwenview;
            "image/tiff" = gwenview;
            "image/webp" = gwenview;
            "text/html" = helium;
            "text/plain" = neovim;
            "x-scheme-handler/http" = helium;
            "x-scheme-handler/https" = helium;
          };
          removed."inode/directory" = [ "kitty-open.desktop" ];
        };
      };
    };
}
