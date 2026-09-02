{
  config,
  self',
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.helium;
in
{
  options.dotfiles.apps.helium.enable = lib.mkEnableOption "Helium browser";

  config = lib.mkIf cfg.enable {
    hj.packages = [ self'.packages.${pkgs.stdenv.hostPlatform.system}.helium-browser ];

    hj.xdg.config.files."net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm" = {
      text = ''
        {"Path": "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"}
      '';
      type = "copy";
    };
  };
}
