{
  config,
  inputs',
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.kanata.fructose;
  kanataConfig = pkgs.writeText "kanata.kbd" config.services.kanata.keyboards.default.config;
  fructose = inputs'.fructose.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      cp ${kanataConfig} kanata.kbd
    '';
  });
in
{
  options.dotfiles.kanata.fructose.enable = lib.mkEnableOption "Fructose";

  config = lib.mkIf cfg.enable {
    systemd.services.fructose = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "kanata-default.service" "openrgb.service" ];
      after = [ "kanata-default.service" "openrgb.service" ];
      bindsTo = [ "kanata-default.service" "openrgb.service" ];
      partOf = [ "kanata-default.service" "openrgb.service" ];
      serviceConfig = {
        ExecStart = lib.getExe' fructose "fructose";
        Restart = "always";
        RestartSec = "1s";
      };
    };
  };
}
