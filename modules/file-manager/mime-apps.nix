{ ... }:

{
  flake.modules.homeManager.file-manager =
    { ... }:
    let
      gwenview = [ "org.kde.gwenview.desktop" ];
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
          "inode/directory" = dolphin;
          "image/bmp" = gwenview;
          "image/gif" = gwenview;
          "image/jpeg" = gwenview;
          "image/png" = gwenview;
          "image/svg+xml" = gwenview;
          "image/tiff" = gwenview;
          "image/webp" = gwenview;
          "text/plain" = neovim;
        };
        associations = {
          added = {
            "application/pdf" = okular;
            "inode/directory" = dolphin;
            "image/bmp" = gwenview;
            "image/gif" = gwenview;
            "image/jpeg" = gwenview;
            "image/png" = gwenview;
            "image/svg+xml" = gwenview;
            "image/tiff" = gwenview;
            "image/webp" = gwenview;
            "text/plain" = neovim;
          };
          removed."inode/directory" = [ "kitty-open.desktop" ];
        };
      };
    };
}
