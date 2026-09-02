{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.dotfiles.dev.zed-editor.enable = lib.mkEnableOption "Zed editor";

  config = lib.mkIf config.dotfiles.dev.zed-editor.enable {
    hj.packages = [ pkgs.zed-editor-fhs ];
  };
}
