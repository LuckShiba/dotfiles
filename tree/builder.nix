{
  runCommand,
  dots,
  findutils,
  coreutils,
  distEtc,
  emptyEtc,
  hjemManifest,
  ignoreFile ? "",
}:

let
  builderScript = dots.lib.writeNuBin "tree-builder" ''
    let src = $env.SRC
    let ref = $env.REF
    let out = $env.out
    let ignore_path = ($env.IGNORE_FILE? | default "")

    let ignores = if ($ignore_path | is-not-empty) and ($ignore_path | path exists) {
        open $ignore_path
        | lines
        | where { |it| not ($it | str starts-with "#") and ($it | str trim | is-not-empty) }
    } else {
        []
    }

    mkdir $out

    ^find -L $src -type f | lines | par-each { |f|
        let r = ($f | path relative-to $src)
        let matches_ignore = ($ignores | any { |pat| $r =~ ($pat | str replace -a "*" ".*") })

        if not $matches_ignore {
            let ref_f = ($ref | path join $r)
            let out_f = ($out | path join $r)

            let needs_copy = if not ($ref_f | path exists) {
                true
            } else {
                (open -r $f | hash md5) != (open -r $ref_f | hash md5)
            }

            if $needs_copy {
                mkdir ($out_f | path dirname)
                do -i { ^cp -Lf $f $out_f }
            }
        }
    }

    if ($env.MANIFEST? | is-not-empty) and ($env.MANIFEST | path exists) {
        let manifest = (open $env.MANIFEST)
        $manifest.files | par-each { |entry|
            let r = ($entry.target | path relative-to "/")
            let matches_ignore = ($ignores | any { |pat| $r =~ ($pat | str replace -a "*" ".*") })

            if not $matches_ignore {
                let dest = ($out | path join $r)
                mkdir ($dest | path dirname)
                do -i { ^cp -LRf $entry.source $dest }
            }
        }
    }
  '';
in
runCommand "build-file-tree" {
  nativeBuildInputs = [
    findutils
    coreutils
  ];

  SRC = distEtc;
  REF = emptyEtc;
  MANIFEST = hjemManifest;
  IGNORE_FILE = ignoreFile;
} "${builderScript}"
