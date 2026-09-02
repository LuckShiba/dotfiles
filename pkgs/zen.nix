{
  extraPolicies ? { },
  inputs,
  system,
  pkgs,
}:
let
  zenPackages = inputs.zen-browser.packages.${system};

  zen-unwrapped = zenPackages.beta-unwrapped.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ (with pkgs; [ zip unzip ]);

    postFixup = (oldAttrs.postFixup or "") + ''
      (
        OMNI_PATH="$out/lib/${oldAttrs.passthru.libName}/browser/omni.ja"
        WORKSPACE=$(mktemp -d)

        unzip -q "$OMNI_PATH" -d "$WORKSPACE" || true

        rm "$OMNI_PATH"
        cd "$WORKSPACE"

        substituteInPlace localization/en-US/browser/preferences/preferences.ftl \
          --replace-fail 'Good choice.' 'Good boy.'

        substituteInPlace localization/de/browser/preferences/preferences.ftl \
          --replace-fail 'Gute Wahl.' 'Guter Hund.'

        zip -0DXqr "$OMNI_PATH" ./*
        rm -rf "$WORKSPACE"
      )
    '';
  });

in
(pkgs.wrapFirefox zen-unwrapped {
  icon = "zen-browser";
  inherit extraPolicies;
})
// {
  unwrapped = zen-unwrapped;
}
