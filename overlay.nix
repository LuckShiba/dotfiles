{ pins, lib }:
final: prev: {
  dots =
    (import ./pkgs {
      inherit pins;
      pkgs = final;
    })
    // {
      lib = import ./lib {
        inherit lib;
        pkgs = final;
      };
    };
}
