{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.kitty;
in
{
  options.dotfiles.apps.kitty = {
    enable = lib.mkEnableOption "Kittyyyy";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = with pkgs; [
      kitty
      nerd-fonts.blex-mono
    ];

    hj.xdg.config.files."kitty/kitty.conf" = {
      source = ./kitty.conf;
      type = "copy";
    };
  };
}
