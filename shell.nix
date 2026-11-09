{
  system ? builtins.currentSystem,
  pins ? import ./.tack { },
  pkgs ? import pins.nixpkgs { inherit system; },
  ...
}:

pkgs.mkShell {
  packages = with pkgs; [
    nil
    nixd
    nixfmt
    (pins.tack.packages.${system}.tack.overrideAttrs {
      doCheck = false;
    })
  ];

  TACK_NIX_CONF_TOKENS = 1;
}
