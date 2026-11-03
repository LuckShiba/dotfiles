{
  inputs,
  pkgs,
  ...
}:
let
  helix = pkgs.lib'.fromInput inputs.helix;

  zen = pkgs.callPackage ./zen.nix {
    inherit inputs;
  };
in
{
  helium-browser = pkgs.callPackage ./helium-browser.nix {
    src = inputs.helium-linux;
    inherit (inputs._meta.helium-linux) version;
  };
  inherit helix zen;
  zen-unwrapped = zen.unwrapped;
  default = helix;
}
