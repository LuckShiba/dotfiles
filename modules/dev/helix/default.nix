{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.dev.helix;
in
{
  options.dotfiles.dev.helix.enable = lib.mkEnableOption "Helix";

  config = lib.mkIf cfg.enable {
    hj.packages = [ pkgs.dots.helix ];

    hj.xdg.config.files = {
      "helix/config.toml".source = ./config.toml;
      "helix/languages.toml".source = ./languages.toml;
      "helix/runtime/queries/kanata".source = ./kanata;
    };
  };
}
