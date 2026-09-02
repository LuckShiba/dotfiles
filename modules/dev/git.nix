{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.dev.git;
  userCfg = config.dotfiles.user;
in
{
  options.dotfiles.dev.git.enable = lib.mkEnableOption "Git configuration";

  config = lib.mkIf cfg.enable {
    hj.xdg.config.files."git/config" = {
      generator = lib.generators.toGitINI;
      value = {
        user = {
          name = userCfg.name;
          email = userCfg.email;
        };
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta = {
          navigate = true;
          light = false;
          "side-by-side" = true;
        };
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };
    };

    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };
}
