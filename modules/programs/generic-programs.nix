{ pkgs, lib, config, ... }:
let
  inherit (lib) types literalExpression hm platforms;
  inherit (lib.lists) last optional toList length;
  inherit (lib.strings) splitString optionalString concatStringsSep;
  inherit (lib.options) mkEnableOption mkPackageOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) foldlAttrs recursiveUpdate optionalAttrs;
  inherit (lib.hm) maintainers;

  programs = with maintainers; {
    bacon = {
      type = "toml";
      description = "bacon, a background rust code checker";
      xdgConfig = "bacon/prefs.toml";
      settings = {
        see = "<https://dystroy.org/bacon/#global-preferences>";
        example = {
          jobs.default = {
            command = [ "cargo" "build" "--all-features" "--color" "always" ];
            need_stdout = true;
          };
        };
      };
      maintainers = [ shimunn princess ];
    };
    cava = {
      type = "ini";
      description = "Cava audio visualizer";
      xdgConfig = "cava/config";
      settings = {
        see =
          "<https://github.com/karlstav/cava/blob/master/example_files/config>";
        example = literalExpression ''
          {
            general.framerate = 60;
            input.method = "alsa";
            smoothing.noise_reduction = 88;
            color = {
              background = "'#000000'";
              foreground = "'#FFFFFF'";
            };
          }
        '';
      };
      maintainers = [ bddvlpr princess ];
    };
    comodoro = {
      type = "toml";
      description = "Comodoro, a CLI to manage your time";
      xdgConfig = "comodoro/config.toml";
      settings.see = "<https://pimalaya.org/comodoro/cli/configuration/>";
      mainainers = [ soywod princess ];
    };
    fuzzel = {
      type = "ini";
      xdgConfig = "fuzzel/fuzzel.ini";
      settings = {
        see = "{manpage}`fuzzel.ini(5)`";
        example = literalExpression ''
          {
            main = {
              terminal = "''${pkgs.foot}/bin/foot";
              layer = "overlay";
            };
            colors.background = "ffffffff";
          }
        '';
      };
      assertions = [
        (hm.assertions.assertPlatform "programs.fuzzel" pkgs platforms.linux)
      ];
      maintainers = [ Scrumplex princess ];
    };
    gallery-dl = {
      type = "json";
      xdgConfig = "gallery-dl/config.json";
      settings = {
        see = "<https://github.com/mikf/gallery-dl#configuration>";
        example = literalExpression ''
          {
            extractor.base-directory = "~/Downloads";
          }
        '';
      };
      maintainers = [ princess ];
    };
    git-cliff = {
      type = "toml";
      description = "git-cliff changelog generator";
      xdgConfig = "git-cliff/cliff.toml";
      settings = {
        see = "<https://git-cliff.org/docs/configuration>";
        example = literalExpression ''
          {
            header = "Changelog";
            trim = true;
          }
        '';
      };
      maintainers = [ NateCox princess ];
    };
    havoc = {
      type = "ini";
      description = "Havoc terminal";
      xdgConfig = "havoc.cfg";
      settings = {
        see = "<https://raw.githubusercontent.com/ii8/havoc/master/havoc.cfg>";
        example = literalExpression ''
          {
            child.program = "bash";
            window.opacity = 240;
            window.margin = no;
            terminal = {
              rows = 80;
              columns = 24;
              scrollback = 2000;
            };
            bind = {
              "C-S-c" = "copy";
              "C-S-v" = "paste";
              "C-S-r" = "reset";
              "C-S-Delete" = "hard reset";
              "C-S-j" = "scroll down";
              "C-S-k" = "scroll up";
              "C-S-Page_Down" = "scroll down page";
              "C-S-Page_Up" = "scroll up page";
              "C-S-End" = "scroll to bottom";
              "C-S-Home" = "scroll to top";
            };
          }
        '';
      };
      assertions = [
        (hm.assertions.assertPlatform "programs.havoc" pkgs platforms.linux)
      ];
      maintainers = [ AndersonTorres princess ];
    };
    hyfetch = {
      type = "json";
      settings.example = literalExpression ''
        {
          preset = "rainbow";
          mode = "rgb";
          color_align = {
            mode = "horizontal";
          };
        }
      '';
      xdgConfig = "hyfetch.json";
      maintainers = [ lilyinstarlight princess ];
    };
    imv = {
      type = "ini";
      description =
        "imv: a command line image viewer intended for use with tiling window managers";
      xdgConfig = "imv/config";
      settings = {
        see = "{manpage}`imv(5)`";
        example = literalExpression ''
          {
            options.background = "ffffff";
            aliases.x = "close";
          }
        '';
      };
      assertions =
        [ (hm.assertions.assertPlatform "programs.imv" pkgs platforms.linux) ];
      maintainers = [ christoph-heiss princess ];
    };
    looking-glass-client = {
      type = "ini";
      xdgConfig = "looking-glass/client.ini";
      settings.example = literalExpression ''
        {
          app = {
            allowDMA = true;
            shmFile = "/dev/kvmfr0";
          };

          win = {
            fullScreen = true;
            showFPS = false;
            jitRender = true;
          };

          spice = {
            enable = true;
            audio = true;
          };

          input = {
            rawMouse = true;
            escapeKey = 62;
          };
        }
      '';
      assertions = [
        (hm.assertions.assertPlatform "programs.looking-glass-client" pkgs
          platforms.linux)
      ];
      maintainers = [ j-brn princess ];
    };
    micro = {
      type = "json";
      xdgConfig = "micro/settings.json";
      settings = {
        see =
          "<https://github.com/zyedidia/micro/blob/master/runtime/help/options.md>";
        example = literalExpression ''
          {
            autosu = false;
            cursorline = false;
          }
        '';
      };
      maintainers = [ mforster princess ];
    };
    ncspot = {
      type = "toml";
      xdgConfig = "ncspot/config.toml";
      settings = {
        see = "<https://github.com/hrkfdn/ncspot#configuration>";
        example = literalExpression ''
          {
            shuffle = true;
            gapless = true;
          }
        '';
      };
      maintainers = [ princess ];
    };
    noti = {
      type = "yaml";
      xdgConfig = "noti/noti.yaml";
      settings = {
        see = "{manpage}`noti.yaml(5)`";
        example = literalExpression ''
          {
            say = {
              voice = "Alex";
            };
            slack = {
              token = "1234567890abcdefg";
              channel = "@jaime";
            };
          }
        '';
      };
      maintainers = [ princess ];
    };
    piston-cli = {
      type = "yaml";
      description = "piston-cli, code runner";
      xdgConfig = "piston-cli/config.yml";
      settings.example = literalExpression ''
        {
          theme = "emacs";
          box_style = "MINIMAL_DOUBLE_HEAD";
          prompt_continuation = "...";
          prompt_start = ">>>";
        }
      '';
      maintainers = [ ethancedwards8 princess ];
    };
    pqiv = {
      type = "ini";
      description = "pqiv image viewer";
      xdgConfig = "pqivrc";
      settings = {
        see = ''
          <link xlink:href="https://github.com/phillipberndt/pqiv/blob/master/pqiv.1"/>'';
        example = literalExpression ''
          {
            options = {
              lazy-load = 1;
              hide-info-box = 1;
              background-pattern = "black";
              thumbnail-size = "256x256";
              command-1 = "thunar";
            };
          };
        '';
      };
      assertions =
        [ (hm.assertions.assertPlatform "programs.pqiv" pkgs platforms.linux) ];
      maintainers = [ donovanglover princess ];
    };
    ruff = {
      type = "toml";
      description =
        "ruff, an extremely fast Python linter and code formatter, written in Rust";
      xdgConfig = "ruff/ruff.toml";
      settings = {
        see = "<https://docs.astral.sh/ruff/settings>";
        example = literalExpression ''
          {
            line-length = 100;
            per-file-ignores = { "__init__.py" = [ "F401" ]; };
            lint = {
              select = [ "E4" "E7" "E9" "F" ];
              ignore = [ ];
            };
          }
        '';
      };
      maintainers = [ GaetanLepage princess ];
    };
    sqls = {
      type = "yaml";
      description = "sqls, a SQL language server written in Go";
      xdgConfig = "sqls/config.yml";
      settings = {
        see = "<https://github.com/lighttiger2505/sqls#db-configuration>";
        example = literalExpression ''
          {
             lowercaseKeywords = true;
             connections = [
               {
                 driver = "mysql";
                 dataSourceName = "root:root@tcp(127.0.0.1:13306)/world";
               }
             ];
          }
        '';
      };
      maintainers = [ princess ];
    };
    topgrade = {
      type = "toml";
      xdgConfig = "topgrade.toml";
      settings = {
        see = "<https://github.com/r-darwish/topgrade/wiki/Step-list>";
        example = literalExpression ''
          {
            assume_yes = true;
            disable = [
              "flutter"
              "node"
            ];
            set_title = false;
            cleanup = true;
            commands = {
              "Run garbage collection on Nix store" = "nix-collect-garbage";
            };
          }
        '';
      };
      maintainers = [ msfjarvis princess ];
    };
    vim-vint = {
      type = "yaml";
      description = "the Vint linter for Vimscript";
      xdgConfig = ".vintrc.yaml";
      maintainers = [ tomodachi94 ];
    };
    wpaperd = {
      type = "toml";
      xdgConfig = "wpaperd/wallpaper.toml";
      settings = {
        see = "<https://github.com/danyspin97/wpaperd#wallpaper-configuration>";
        example = literalExpression ''
          {
            eDP-1 = {
              path = "/home/foo/Pictures/Wallpaper";
              apply-shadow = true;
            };
            DP-2 = {
              path = "/home/foo/Pictures/Anime";
              sorting = "descending";
            };
          }
        '';
      };
      maintainers = [ Avimitin princess ];
    };
  };
in foldlAttrs (a: n: v:
  let
    cfg = config.programs.${n};
    format = pkgs.formats.${v.type} { };
    configFile =
      format.generate (last (splitString "/" v.xdgConfig)) cfg.settings;
    settings = v.settings or { };
    sees = toList settings.see or [ ];
  in recursiveUpdate a {
    meta.maintainers = v.maintainers or [ ];

    options.programs.${n} = {
      enable = mkEnableOption (v.description or n);
      package = mkPackageOption pkgs n { };
      settings = mkOption {
        type = format.type;
        default = { };
        description = ''
          Configuration written to <filename>$XDG_CONFIG_HOME/${v.xdgConfig}</filename>.
        '' + optionalString (length sees > 0) ''
          See ${concatStringsSep " or " sees} for available options.
        '';
      } // optionalAttrs (settings ? example) { example = settings.example; };
    };

    config = mkIf cfg.enable {
      assertions = v.assertions or [ ];
      home.packages = [ cfg.package ];
      xdg.configFile.${v.xdgConfig} =
        mkIf (cfg.settings != { }) { source = configFile; };
    };
  }) { } programs
