{
  system ? builtins.currentSystem,
  pins ? import ./.tack { },
}:

let
  inherit (pins.nixpkgs) lib;

  overlay = import ./overlay.nix { inherit pins lib; };
  nixos = import ./nixos.nix { inherit pins overlay; };

  pkgs = import pins.nixpkgs {
    inherit system;
    overlays = [ overlay ];
  };

  tree = import ./tree {
    inherit
      nixos
      pkgs
      lib
      system
      ;
  };
in

import ./pkgs { inherit pins pkgs; }
// {
  inherit
    nixos
    overlay
    tree
    ;
  shell = import ./shell.nix { inherit system pins pkgs; };
}
