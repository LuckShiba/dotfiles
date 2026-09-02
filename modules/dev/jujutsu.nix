{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.dev.jujutsu;
  userCfg = config.dotfiles.user;
in
{
  options.dotfiles.dev.jujutsu.enable = lib.mkEnableOption "Jujutsu";

  config = lib.mkIf cfg.enable {
    hj.packages = [ pkgs.jujutsu ];

    hj.xdg.config.files."jj/config.toml" = {
      generator = (pkgs.formats.toml { }).generate "jj-config.toml";
      value = {
        user = {
          inherit (userCfg) name email;
        };
        ui.pager = "delta";
        ui.diff.formatter = "git";
      };
    };
  };
}
