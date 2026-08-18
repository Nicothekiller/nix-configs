{
  appimageTools,
  dpkg,
  lib,
  libpng,
  libxkbfile,
  stdenvNoCC,
  src,
  version,
}:

let
  appimage = stdenvNoCC.mkDerivation {
    pname = "cisco-packet-tracer-appimage";
    inherit version;

    src = src;

    nativeBuildInputs = [
      dpkg
    ];

    installPhase = ''
      runHook preInstall

      cp opt/pt/packettracer.AppImage $out

      runHook postInstall
    '';
  };
in
appimageTools.wrapType2 rec {
  pname = "cisco-packet-tracer";
  inherit version;

  src = appimage;

  extraPkgs = _: [
    libpng
    libxkbfile
  ];

  extraBwrapArgs = [
    "--setenv QT_QPA_PLATFORM xcb"
  ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      mv $out/bin/${pname} $out/bin/packettracer9

      install -Dm444 ${contents}/CiscoPacketTracer-${version}.desktop $out/share/applications/cisco-packet-tracer.desktop
      install -Dm444 ${contents}/CiscoPacketTracerPtsa-${version}.desktop $out/share/applications/cisco-packet-tracer-ptsa.desktop
      substituteInPlace $out/share/applications/* \
        --replace-fail "Exec=@EXEC_PATH@" "Exec=packettracer9" \
        --replace-fail "Icon=app" "Icon=cisco-packet-tracer"

      install -Dm444 ${contents}/usr/share/icons/hicolor/48x48/apps/app.png $out/share/icons/hicolor/48x48/apps/cisco-packet-tracer.png
      cp -r ${contents}/usr/share/icons/gnome/48x48/mimetypes $out/share/icons/hicolor/48x48/

      for desktop in $out/share/applications/*.desktop; do
        sed -i '/^\[Desktop Entry\]/a StartupWMClass=PacketTracer' "$desktop"
      done
    '';

  meta = {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    license = lib.licenses.unfree;
    mainProgram = "packettracer9";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
