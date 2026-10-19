{
  config,
  self',
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
    hj.packages = [ self'.packages.${pkgs.stdenv.hostPlatform.system}.helix ];

    hj.xdg.config.files = {
      "helix/config.toml".source = ./config.toml;
      "helix/languages.toml".source = ./languages.toml;
      "helix/runtime/queries/kanata".source = ./kanata;
    };
  };
}
