{
  config,
  self',
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.zen-browser;
  mkExtensionSettings = builtins.mapAttrs (
    _: pluginId: {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
      installation_mode = "force_installed";
    }
  );
in
{
  options.dotfiles.apps.zen-browser.enable = lib.mkEnableOption "Zen browser";

  config = lib.mkIf cfg.enable {
    hj.packages = [
      (self'.packages.${pkgs.stdenv.hostPlatform.system}.zen.override {
        extraPolicies = {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          ExtensionSettings = mkExtensionSettings {
            "uBlock0@raymondhill.net" = "ublock-origin";
            "sponsorBlocker@ajay.app" = "sponsorblock";
            "addon@darkreader.org" = "darkreader";
            "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
          };
        };
      })
    ];
  };
}
