{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.zellij;
in
{
  options.dotfiles.apps.zellij.enable = lib.mkEnableOption "Zellij";

  config = lib.mkIf cfg.enable {
    hj.packages = [ pkgs.zellij ];

    hj.xdg.config.files."zellij/config.kdl" = {
      source = ./config.kdl;
      type = "copy";
    };
  };
}
