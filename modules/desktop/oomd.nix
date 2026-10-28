{ config, lib, ... }:
{
  options.dotfiles.desktop.oomd.enable = lib.mkEnableOption "systemd-oomd";

  config = lib.mkIf config.dotfiles.desktop.oomd.enable {
    systemd.oomd = {
      enable = true;
      enableRootSlice = true;
      enableSystemSlice = true;
      enableUserSlices = true;
      settings.OOM.DefaultMemoryPressureDurationSec = "15s";
    };
  };
}
