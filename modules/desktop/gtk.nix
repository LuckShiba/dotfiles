{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.desktop.gtk;
  themePkg = pkgs.adw-gtk3;
  themeName = "adw-gtk3";
  cursorName = "breeze_cursors";
  gtkSettings = lib.generators.toINI { } {
    Settings = {
      gtk-cursor-theme-name = cursorName;
      gtk-cursor-theme-size = 24;
      gtk-theme-name = themeName;
    };
  };
in
{
  options.dotfiles.desktop.gtk = {
    enable = lib.mkEnableOption "GTK theming";
  };

  config = lib.mkIf cfg.enable {
    hj.xdg.config.files = {
      "gtk-3.0/gtk.css" = {
        text = ''
          @import url("dank-colors.css");
        '';
        type = "copy";
      };
      "gtk-3.0/settings.ini" = {
        text = gtkSettings;
        type = "copy";
      };
      "gtk-4.0/gtk.css" = {
        text = ''
          @import url("file://${themePkg}/share/themes/${themeName}/gtk-4.0/gtk.css");
          @import url("dank-colors.css");
        '';
        type = "copy";
      };
      "gtk-4.0/settings.ini" = {
        text = gtkSettings;
        type = "copy";
      };
    };

    hj.packages = [ pkgs.adw-gtk3 ];
  };
}
