{
  outputs =
    { self, ... }@args:
    let
      inputs = (import ./.tack) {
        overrides = args.tackOverrides or { };
      };
      inherit (inputs) nixpkgs;

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
            inputs.dux-calendar.nixosModules.default
            inputs.dux-plugin-registry.nixosModules.default
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
            inputs.tack.packages.${system}.tack
          ];

          TACK_NIX_CONF_TOKENS = 1;
        };
      });
    };
}
