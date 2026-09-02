{
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.kanata;
  deviceList = lib.concatMapStringsSep "\n" (device: ''            "${device}"'') cfg.devices;
in
{
  options.dotfiles.kanata = {
    enable = lib.mkEnableOption "Kanata";
    port = lib.mkOption {
      type = lib.types.int;
      default = 62199;
    };
    devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards.default = {
        port = cfg.port;

        extraDefCfg = ''
          process-unmapped-keys yes
          concurrent-tap-hold yes
          allow-hardware-repeat false
          linux-dev-names-include (
            ${deviceList}
          )
          log-layer-changes no
        '';

        config = builtins.readFile ./keyboard.kbd;
      };
    };
  };
}
