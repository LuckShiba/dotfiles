{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles;
in
{
  imports = [
    (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" config.dotfiles.user.username ])
    ./apps
    ./desktop
    ./dev
    ./kanata
    ./kanata/fructose.nix
  ];

  options.dotfiles = {
    enable = lib.mkEnableOption "dotfiles??";

    user = {
      username = lib.mkOption {
        type = lib.types.str;
      };

      homeDirectory = lib.mkOption {
        type = lib.types.str;
        default = "/home/${config.dotfiles.user.username}";
      };

      name = lib.mkOption {
        type = lib.types.str;
      };

      email = lib.mkOption {
        type = lib.types.str;
      };

      editor = lib.mkOption {
        type = lib.types.str;
        default = "hx";
      };

      shell = lib.mkOption {
        type = lib.types.enum [
          "fish"
          "zsh"
        ];
        default = "fish";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hjem.users.${cfg.user.username} = {
      enable = true;
      user = cfg.user.username;
      directory = cfg.user.homeDirectory;
    };

    hj.packages =
      with pkgs;
      [
        lazygit
        fzf
        bat
        delta
        eza
        ripgrep
        fd
        wget2
        dust
        duf
        bat-extras.batman
        bat-extras.batdiff
        bat-extras.prettybat
        bat-extras.batgrep
      ];

    hj.environment.sessionVariables = {
      PAGER = "bat";
    };

    hj.files.".profile".source = config.hj.environment.loadEnv;

    programs.zoxide.enable = true;
    programs.pay-respects.enable = true;
    programs.gnupg.agent.enable = true;
  };
}
