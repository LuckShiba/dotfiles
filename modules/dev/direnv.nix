{
  config,
  lib,
  ...
}:
{
  options.dotfiles.dev.direnv.enable = lib.mkEnableOption "direnv support";

  config = lib.mkIf config.dotfiles.dev.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
