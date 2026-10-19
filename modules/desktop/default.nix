{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./gtk.nix
    ./niri
  ];

  options.dotfiles.desktop.enable = lib.mkEnableOption "desktop dotfiles";

  config = lib.mkIf config.dotfiles.desktop.enable {
    hj.packages = with pkgs; [
      ((ffmpeg-full.override { withUnfree = true; }).overrideAttrs (_: { doCheck = false; }))
      adwaita-icon-theme
      nautilus
      gsettings-desktop-schemas
      kdePackages.breeze
    ];

    hj.environment.sessionVariables.GSETTINGS_SCHEMA_DIR =
      pkgs.glib.makeSchemaPath pkgs.gsettings-desktop-schemas pkgs.gsettings-desktop-schemas.name;

    hj.xdg.config.files."user-dirs.dirs".text = ''
      XDG_DESKTOP_DIR="$HOME/Desktop"
      XDG_DOWNLOAD_DIR="$HOME/Downloads"
      XDG_TEMPLATES_DIR="$HOME/Templates"
      XDG_PUBLICSHARE_DIR="$HOME/Public"
      XDG_DOCUMENTS_DIR="$HOME/Documents"
      XDG_MUSIC_DIR="$HOME/Music"
      XDG_PICTURES_DIR="$HOME/Pictures"
      XDG_VIDEOS_DIR="$HOME/Videos"
    '';

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };

    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };
  };
}
