{ lib, self }:
{
  empty = lib.nixosSystem {
    modules = [
      {
        services.graphical-desktop.enable = true;
        programs.fish.enable = true;
      }
    ];
    system = "x86_64-linux";
  };

  dist = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.default
      {
        nixpkgs.config.allowUnfree = true;

        users.users.luckshiba = {
          isNormalUser = true;
          packages = lib.mkForce [ ];
        };

        programs.dux-shell.plugins = lib.mkForce { };

        dotfiles = {
          enable = true;

          user = {
            name = "LuckShiba";
            username = "luckshiba";
            email = "shiba@luckshiba.dev";
            shell = "fish";
          };

          apps = {
            helium.enable = true;
            kitty.enable = true;
            zellij.enable = true;
            zen-browser.enable = true;
          };

          dev = {
            direnv.enable = true;
            git.enable = true;
            jujutsu.enable = true;
            helix.enable = true;
            zed-editor.enable = true;
          };

          desktop = {
            enable = true;
            gtk.enable = true;
            kdeconnect.enable = true;
            oomd.enable = true;
            speech.enable = true;
            dms.enable = true;
            niri.enable = true;
            vellum.enable = true;
          };

          kanata = {
            enable = true;
            fructose.enable = true;
          };
        };
      }
    ];
  };
}
