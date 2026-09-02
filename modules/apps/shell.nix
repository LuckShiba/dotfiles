{
  config,
  lib,
  pkgs,
  ...
}:
let
  userCfg = config.dotfiles.user;
  isFish = userCfg.shell == "fish";
  isZsh = userCfg.shell == "zsh";
in
{
  config = lib.mkIf config.dotfiles.enable {
    programs.fish = lib.mkIf isFish {
      enable = true;

      interactiveShellInit =
        let
          mkFishInit' = package: args: "${lib.getExe package} ${args} | source";
          mkFishInit = module: args: mkFishInit' config.programs.${module}.package args;
        in
        lib.concatLines (
          [
            (mkFishInit' pkgs.nix-your-shell "fish")
            (mkFishInit' pkgs.fzf "--fish")
            (mkFishInit "zoxide" "init fish")
            (mkFishInit "pay-respects" "fish")
            (mkFishInit "direnv" "hook fish")
            ''
              if test "$TERM" != "dumb"
                ${mkFishInit "starship" "init fish"}
              end
            ''
          ]
          # source: https://github.com/nix-community/home-manager/blob/3ee51fbdac8c8bdfe1e7e1fcaba6520a563f394f/modules/programs/kitty.nix#L64
          ++ lib.optional config.dotfiles.apps.kitty.enable ''
            if set -q KITTY_INSTALLATION_DIR
              set --global KITTY_SHELL_INSTALLATION no-rc
              source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
              set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
            end
          ''
        );

      shellAliases = {
        ls = "eza --icons auto";
        ll = "eza -l --icons auto";
        la = "eza -a --icons auto";
        lt = "eza --tree --icons auto";
        lla = "eza -la --icons auto";
        tree = "eza --tree --icons";
        man = "batman";
      };
    };

    programs.zsh = lib.mkIf isZsh {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        tree = "eza --tree --icons";
        man = "batman";
      };
      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "history"
          "fzf"
          "eza"
          "zoxide"
        ];
      };
    };

    programs.starship = {
      enable = true;

      # https://starship.rs/presets/nerd-font
      settings = {
        aws.symbol = " ";
        buf.symbol = " ";
        bun.symbol = " ";
        c.symbol = " ";
        cpp.symbol = " ";
        cmake.symbol = " ";
        conda.symbol = " ";
        crystal.symbol = " ";
        dart.symbol = " ";
        deno.symbol = " ";
        directory.read_only = " 󰌾";
        docker_context.symbol = " ";
        elixir.symbol = " ";
        elm.symbol = " ";
        fennel.symbol = " ";
        fortran.symbol = " ";
        fossil_branch.symbol = " ";
        gcloud.symbol = " ";
        git_branch.symbol = " ";
        git_commit.tag_symbol = "  ";
        golang.symbol = " ";
        gradle.symbol = " ";
        guix_shell.symbol = " ";
        haskell.symbol = " ";
        haxe.symbol = " ";
        hg_branch.symbol = " ";
        hostname.ssh_symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        kotlin.symbol = " ";
        lua.symbol = " ";
        memory_usage.symbol = "󰍛 ";
        meson.symbol = "󰔷 ";
        nim.symbol = "󰆥 ";
        nix_shell.symbol = " ";
        nodejs.symbol = " ";
        ocaml.symbol = " ";
        os.symbols = {
          Alpaquita = " ";
          Alpine = " ";
          AlmaLinux = " ";
          Amazon = " ";
          Android = " ";
          AOSC = " ";
          Arch = " ";
          Artix = " ";
          CachyOS = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          Nobara = " ";
          OpenBSD = "󰈺 ";
          openSUSE = " ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          RockyLinux = " ";
          Redox = "󰀘 ";
          Solus = "󰠳 ";
          SUSE = " ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
        };
        package.symbol = "󰏗 ";
        perl.symbol = " ";
        php.symbol = " ";
        pijul_channel.symbol = " ";
        pixi.symbol = "󰏗 ";
        python.symbol = " ";
        rlang.symbol = "󰟔 ";
        ruby.symbol = " ";
        rust.symbol = "󱘗 ";
        scala.symbol = " ";
        status.symbol = " ";
        swift.symbol = " ";
        xmake.symbol = " ";
        zig.symbol = " ";
      };
    };
  };
}
