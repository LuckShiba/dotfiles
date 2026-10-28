{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "";
    };

    helix = {
      url = "github:luckshiba/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:LuckShiba/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xwl-s = {
      url = "github:Supreeeme/xwayland-satellite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dank-greeter = {
      url = "github:AvengeMedia/dank-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankcalendar = {
      url = "github:AvengeMedia/dankcalendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fructose = {
      url = "github:LuckShiba/fructose";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
      ];
      forEachSystem = lib.genAttrs systems;
    in
    {
      nixosModules = {
        default = {
          imports = [
            inputs.hjem.nixosModules.default
            self.nixosModules.dotfiles
          ];
        };
        dotfiles = {
          _module.args.self' = self;
          _module.args.inputs' = inputs;
          imports = [
            ./modules
            inputs.dankcalendar.nixosModules.default
            inputs.dms-plugin-registry.nixosModules.default
          ];
        };
        raw = self.nixosModules.dotfiles;
      };

      packages = forEachSystem (
        system:
        import ./pkgs {
          inherit self inputs system;
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );

      formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt);

      devShells = forEachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            nil
            nixd
            nixfmt
          ];
        };
      });
    };
}
