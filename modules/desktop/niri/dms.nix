{
  config,
  pkgs,
  lib,
  inputs',
  ...
}:
let
  cfg = config.dotfiles.desktop.niri;
  dmsCfg = config.dotfiles.desktop.dms;
  userCfg = config.dotfiles.user;
  dmsPkgs = inputs'.dankMaterialShell.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.dotfiles.desktop.dms = {
    enable = lib.mkEnableOption "DankMaterialShell";
    ippHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    greeter = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      saveLogs = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      outputs = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };
  };

  config = lib.mkIf (cfg.enable && dmsCfg.enable) {
    systemd.user.services.dms.environment = {
      DMS_MODAL_LAYER = "overlay";
    } // lib.optionalAttrs (dmsCfg.ippHost != null) {
      DMS_IPP_HOST = dmsCfg.ippHost;
    };

    dotfiles.desktop.niri.rawKdlExtra = lib.concatLines (
      lib.map (x: "include optional=true \"${x}\"") [
        "dms/colors.kdl"
        "dms/alttab.kdl"
        "dms/layout.kdl"
        "dms/wpblur.kdl"
        "dms/binds.kdl"
        "dms/outputs.kdl"
        "dms/cursor.kdl"
        "dms/windowrules.kdl"
      ]
    );

    programs.dms-shell = {
      enable = true;
      package = dmsPkgs.default.override {
        extraQtPackages = with pkgs.qt6Packages; [ qtwebsockets ];
      };
      systemd.target = "niri.service";

      plugins = {
        dockerManager.enable = true;
        calculator.enable = true;
        dankPomodoroTimer.enable = true;
        niriWindows.enable = true;
      };
    };

    programs.dank-calendar.enable = true;

    services.displayManager.dms-greeter = lib.mkIf dmsCfg.greeter.enable {
      enable = true;
      package = inputs'.dank-greeter.packages.${pkgs.stdenv.hostPlatform.system}.dms-greeter;

      compositor = {
        name = "niri";
        customConfig = ''
          ${dmsCfg.greeter.outputs}
          cursor {
            xcursor-theme "breeze_cursors"
            xcursor-size 24
          }
          hotkey-overlay {
            skip-at-startup
          }

          environment {
            DMS_RUN_GREETER "1"
          }

          gestures {
             hot-corners {
               off
             }
          }

          layout {
            background-color "#000000"
          }
        '';
      };

      configHome = userCfg.homeDirectory;
      logs.save = dmsCfg.greeter.saveLogs;
    };

    hj.packages = [ pkgs.libqalculate ];
  };
}
