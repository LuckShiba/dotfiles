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
    let
      content = if builtins.isPath text then builtins.readFile text else text;
      nuScript = pkgs.writeText "${name}.nu" content;
    in
    pkgs.writeScript name ''
      #!${pkgs.runtimeShell}
      exec ${lib.getExe pkgs.nushell} --no-std-lib -n "${nuScript}" "$@"
    '';
}
