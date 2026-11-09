{ pins, overlay }:
{
  imports = [
    pins.hjem.nixosModules.default
    pins.dux-calendar.nixosModules.default
    pins.dux-plugin-registry.nixosModules.default
    ./modules
    { nixpkgs.overlays = [ overlay ]; }
  ];
}
