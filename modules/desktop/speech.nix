{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.desktop.speech;
in
{
  options.dotfiles.desktop.speech.enable = lib.mkEnableOption "speech";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      piper-tts
      alsa-utils
      speechd
    ];

    services.speechd =
      let
        piperVoice = pkgs.fetchurl {
          url = "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/hfc_male/medium/en_US-hfc_male-medium.onnx";
          hash = "sha256-0R5AOgK99aZwyHez3Fbg4cjOzm+zAolYYxTf/cCnjLA=";
        };
        piperConfig = pkgs.fetchurl {
          url = "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/hfc_male/medium/en_US-hfc_male-medium.onnx.json";
          hash = "sha256-9mhHQkrtC/mey7XXz95HwKkG9Cag2vfEbzBefSGv2IY=";
        };
        piperVoiceDir = pkgs.linkFarm "piper-voice" [
          {
            name = "model.onnx";
            path = piperVoice;
          }
          {
            name = "model.onnx.json";
            path = piperConfig;
          }
        ];
      in
      {
        enable = true;
        config = ''
          AddModule "piper" "sd_generic" "piper.conf"
          DefaultVoiceType "male1"
          DefaultLanguage "en-US"
          DefaultModule piper
        '';
        modules.piper = ''
          GenericExecuteSynth "printf %s \'$DATA\' | ${pkgs.piper-tts}/bin/piper --model ${piperVoiceDir}/model.onnx --output-raw | ${pkgs.alsa-utils}/bin/aplay -r 22050 -f S16_LE -t raw -q -"
          GenericCmdDependency "${pkgs.piper-tts}/bin/piper"
          GenericCmdDependency "${pkgs.alsa-utils}/bin/aplay"

          AddVoice "en-US" "male1" "hfc_male"
        '';
      };
  };
}
