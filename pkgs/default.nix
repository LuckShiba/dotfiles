{
  inputs,
  system,
  pkgs,
  ...
}:
let
  helix = inputs.helix.packages.${system}.helix;

  zen = pkgs.callPackage ./zen.nix {
    inherit inputs system;
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
