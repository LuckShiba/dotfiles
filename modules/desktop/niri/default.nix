{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.desktop.niri;
  userCfg = config.dotfiles.user;

  zen-spawn-focus = pkgs.dots.lib.writeNuBin "zen-spawn-focus" ''
    let focused_ws = niri msg -j workspaces
      | from json
      | where is_focused == true
      | first

    let zen = niri msg -j windows
      | from json
      | where app_id == "zen-beta" and workspace_id == $focused_ws.id
      | sort-by focus_timestamp.secs
      | last

    if ($zen | is-not-empty) {
      niri msg action focus-window --id $zen.id
    } else {
      zen-beta
    }
  '';

  gcc = pkgs.gnome-control-center;
  niriGCC = pkgs.symlinkJoin {
    name = "gnome-control-center-niri";
    paths = [ gcc ];
    nativeBuildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      rm $out/bin/gnome-control-center

      makeWrapper ${gcc}/bin/gnome-control-center $out/bin/gnome-control-center \
        --set XDG_CURRENT_DESKTOP "GNOME"
    '';
  };
in
{
  options.dotfiles.desktop.niri = {
    enable = lib.mkEnableOption "niri";
    keyboard.layout = lib.mkOption {
      type = lib.types.str;
      default = "us(altgr-intl)";
    };
    tablet.output = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    rawKdlExtra = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.niri.serviceConfig = lib.mkIf config.systemd.oomd.enable {
      ManagedOOMMemoryPressure = "avoid";
      ManagedOOMSwap = "avoid";
      ManagedOOMPreference = "avoid";
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    services.gvfs.enable = true;
    security.rtkit.enable = true;

    hj.xdg.config.files."niri/config.kdl" = {
      source = pkgs.replaceVars ./config.kdl {
        keyboardLayout = cfg.keyboard.layout;
        tabletConfig = lib.optionalString (cfg.tablet.output != null) ''
          tablet {
            map-to-output "${cfg.tablet.output}"
          }
        '';
        editor = userCfg.editor;
        zenSpawnFocus = "${zen-spawn-focus}";
        rawKdlExtra = cfg.rawKdlExtra;
      };
      type = "copy";
    };

    hj.packages = [
      pkgs.dots.xwl-s
      pkgs.nushell
      pkgs.jq
      niriGCC
    ];

    services.dbus.packages = [ niriGCC ];

    programs.niri = {
      enable = true;
      package = pkgs.dots.niri.overrideAttrs {
        doCheck = false;
      };
    };

    xdg.portal = {
      config.niri = {
        "org.freedesktop.impl.portal.RemoteDesktop" = "wlr";
      };
      extraPortals = [
        (pkgs.xdg-desktop-portal-wlr.overrideAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "David96";
            repo = "xdg-desktop-portal-wlr";
            rev = "bdd26ad0096290e1cc9a952e18732e8544f783bc";
            hash = "sha256-9km9Gn8EwvASwbcAxDOdOsw/uOsjJfddQXFm5tBPD5c=";
          };
          buildInputs = old.buildInputs ++ [
            pkgs.libxkbcommon
          ];
        }))
      ];
    };
  };
}
