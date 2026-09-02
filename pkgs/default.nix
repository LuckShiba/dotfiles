{
  self,
  inputs,
  system,
  pkgs,
}:
let
  helixPackages = inputs.helix.packages.${system};

  helix =
    if helixPackages ? helix then
      helixPackages.helix
    else
      helixPackages.default;
  zen = pkgs.callPackage ./zen.nix {
    inherit inputs system;
  };
in
{
  helium-browser = pkgs.callPackage ./helium-browser.nix { };
  inherit helix zen;
  zen-unwrapped = zen.unwrapped;
  default = helix;
}
