{
  inputs,
  pkgs,
  ...
}:
rec {
  helium-browser = pkgs.callPackage ./helium-browser.nix {
    src = inputs.helium-linux;
    inherit (inputs._meta.helium-linux) version;
  };
  
  helix = pkgs.lib'.fromInput inputs.helix;
  
  zen = pkgs.callPackage ./zen.nix {
    inherit inputs;
  };
  zen-unwrapped = zen.unwrapped;

  build-file-tree = pkgs.callPackage ./build-file-tree.nix;
}
