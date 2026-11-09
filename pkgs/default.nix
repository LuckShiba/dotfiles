{
  pins,
  pkgs,
  ...
}:
let
  inherit (pkgs.dots.lib) fromInput;
in
{
  helium-browser = pkgs.callPackage ./helium-browser.nix {
    src = pins.helium-linux;
    inherit (pins._meta.helium-linux) version;
  };

  zen = pkgs.callPackage ./zen.nix { inherit pins; };
  zen-unwrapped = pkgs.dots.zen.unwrapped;
}
// pins.nixpkgs.lib.genAttrs [
  "helix"
  "niri"
  "vellum"
  "fructose"
  "xwl-s"
  "dux-shell"
  "dux-greeter"
] (name: fromInput pins.${name})
