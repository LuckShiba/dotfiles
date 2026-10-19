{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "0.19.3.1";
  pname = "helium-browser";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-Rg5tKlyG0DkhYkItGyF6NmMb2DD40h5WUYyWAgl5eQY=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 {${appimageContents},$out/share/applications}/helium.desktop
    install -Dm444 {${appimageContents}/usr,$out}/share/icons/hicolor/256x256/apps/helium.png
    substituteInPlace $out/share/applications/helium.desktop \
      --replace-fail 'Exec=helium' 'Exec=${meta.mainProgram}'
  '';

  meta = {
    description = "Helium Browser";
    homepage = "https://github.com/imputnet/helium-linux";
    downloadPage = "https://github.com/imputnet/helium-linux/releases";
    mainProgram = "helium-browser";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
