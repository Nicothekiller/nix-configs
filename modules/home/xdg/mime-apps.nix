{ ... }:

let
  gwenview = [ "org.kde.gwenview.desktop" ];
  okular = [ "okularApplication_pdf.desktop" ];
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = okular;
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      "image/bmp" = gwenview;
      "image/gif" = gwenview;
      "image/jpeg" = gwenview;
      "image/png" = gwenview;
      "image/svg+xml" = gwenview;
      "image/tiff" = gwenview;
      "image/webp" = gwenview;
    };

    associations = {
      added = {
        "application/pdf" = okular;
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "image/bmp" = gwenview;
        "image/gif" = gwenview;
        "image/jpeg" = gwenview;
        "image/png" = gwenview;
        "image/svg+xml" = gwenview;
        "image/tiff" = gwenview;
        "image/webp" = gwenview;
      };

      removed = {
        "inode/directory" = [ "kitty-open.desktop" ];
      };
    };
  };
}
