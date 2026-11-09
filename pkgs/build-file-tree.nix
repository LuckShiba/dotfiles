{ lib', ... }:
lib'.writeNuBin "build-file-tree" ''
  let src = (nix build --no-link --print-out-paths .#nixosConfigurations.dist.config.system.build.etc | str trim)
  let ref = (nix build --no-link --print-out-paths .#nixosConfigurations.empty.config.system.build.etc | str trim)
  let out = "meow"
  let ignores = if (".treeignore" | path exists) {
      open ".treeignore" | lines | where not ($it | str starts-with "#") and not ($it | is-empty)
  } else { [] }

  ^find -L $src -type f | lines | par-each { |f|
      let r = ($f | path relative-to $src)
      if not ($ignores | any { |pat| $r =~ ($pat | str replace -a "*" ".*") }) {
          let ref_f = ($ref | path join $r)
          let out_f = ($out | path join $r)

          if (not ($ref_f | path exists)) or ((open -r $f | hash md5) != (open -r $ref_f | hash md5)) {
              mkdir ($out_f | path dirname)
              do -i { ^cp -Lf $f $out_f }
          }
      }
  }

  let manifest_dir = (nix eval --raw .#nixosConfigurations.dist.config.systemd.services."hjem-activate@".script | grep -o '/nix/store/[^"]*hjem-manifests')
  let manifest = ($manifest_dir | path join "manifest-luckshiba.json" | open)

  $manifest.files | par-each { |entry|
      let r = ($entry.target | path relative-to "/")
      if not ($ignores | any { |pat| $r =~ ($pat | str replace -a "*" ".*") }) {
          let dest = ($out | path join $r)
          mkdir ($dest | path dirname)
          do -i { ^cp -LRf $entry.source $dest }
      }
  }
''
