{
  config,
  inputs',
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.desktop.niri;
  userCfg = config.dotfiles.user;

  mkNuBin =
    name: text:
    pkgs.writers.makeScriptWriter {
      interpreter = "/usr/bin/env -S ${lib.getExe pkgs.nushell} --no-std-lib -n";
    } name text;

  zen-spawn-focus = mkNuBin "zen-spawn-focus" ''
    let focused_ws = (niri msg -j workspaces | from json
      | where is_focused
      | first)

    let zen = (niri msg -j windows | from json
      | where app_id == "zen-beta" and workspace_id == $focused_ws.id
      | sort-by focus_timestamp.secs
      | last)

    if ($zen | is-not-empty) {
      niri msg action focus-window --id $zen.id
    } else {
      zen-beta
    }
  '';
in
{
  options.dotfiles.desktop.niri = {
    enable = lib.mkEnableOption "niri";
    keyboard.layout = lib.mkOption {
      type = lib.types.str;
      default = "us(altgr-intl)";
    };
    rawKdlExtra = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    hj.xdg.config.files."niri/config.kdl" = {
      source = pkgs.replaceVars ./config.kdl {
        keyboardLayout = cfg.keyboard.layout;
        editor = userCfg.editor;
        zenSpawnFocus = "${zen-spawn-focus}";
        rawKdlExtra = cfg.rawKdlExtra;
      };
      type = "copy";
    };

    hj.packages = [
      pkgs.xwayland-satellite
      pkgs.nushell
      pkgs.jq
    ];

    programs.niri = {
      enable = true;
      package =
        let
          niriPackage = inputs'.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        in
        niriPackage.overrideAttrs {
          doCheck = false;
          patches = [ ./niri-screencast-force-render.patch ];
        };
    };
  };
}
