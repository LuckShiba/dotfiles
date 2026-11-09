{
  outputs =
    { ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      pins = import ./.tack { };
      inherit (pins.nixpkgs) lib;
      forEachSystem = f: lib.genAttrs systems (system: f (import ./. { inherit system pins; }));

      common = import ./. { inherit pins; };
    in
    {
      nixosModules.default = common.nixos;
      overlays.default = common.overlay;

      packages = forEachSystem (
        dots: lib.filterAttrs (_: lib.isDerivation) dots // { default = dots.tree; }
      );
      devShells = forEachSystem (dots: {
        default = dots.shell;
      });
    };
}
