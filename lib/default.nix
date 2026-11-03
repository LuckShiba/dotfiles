{
  lib,
  pkgs,
  ...
}:
rec {
  fromInput' = input: name: input.packages.${pkgs.stdenv.hostPlatform.system}.${name};
  fromInput = input: fromInput' input "default";

  writeNuBin =
    name: text:
    pkgs.writers.makeScriptWriter {
      interpreter = "/usr/bin/env -S ${lib.getExe pkgs.nushell} --no-std-lib -n";
    } name text;
}
