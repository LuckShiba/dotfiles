{
  pkgs,
  lib,
  self,
}:
let
  systems = import ./systems.nix { inherit lib self; };
  dist = systems.dist.config;
  empty = systems.empty.config;
  manifestDir = builtins.elemAt (builtins.match ".*(/nix/store/[^\" \n]+-hjem-manifests).*" (
    dist.systemd.services."hjem-activate@".script
  )) 0;
in
pkgs.callPackage ./builder.nix {
  distEtc = dist.system.build.etc;
  emptyEtc = empty.system.build.etc;
  hjemManifest = "${manifestDir}/manifest-luckshiba.json";
  ignoreFile = ./treeignore;
}
