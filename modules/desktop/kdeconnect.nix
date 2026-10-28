{ config, lib, ... }:
{
  options.dotfiles.desktop.kdeconnect.enable = lib.mkEnableOption "KDE Connect";

  config = lib.mkIf config.dotfiles.desktop.kdeconnect.enable {
    programs.kdeconnect.enable = true;

    systemd.user.services.kdeconnect = {
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      enableDefaultPath = false;

      serviceConfig = {
        ExecStart = lib.getExe' config.programs.kdeconnect.package "kdeconnectd";
        Restart = "on-abort";
      };
    };
  };
}
