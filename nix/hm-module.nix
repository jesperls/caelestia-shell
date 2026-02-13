self:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  cli-default = self.inputs.caelestia-cli.packages.${system}.default;
  shell-default = self.packages.${system}.with-cli;
  colorLib = import ./colors.nix { inherit lib; };

  cfg = config.programs.caelestia;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "programs" "caelestia" "environment" ]
      [ "programs" "caelestia" "systemd" "environment" ]
    )
  ];
  options = with lib; {
    programs.caelestia = {
      enable = mkEnableOption "Enable Caelestia shell";
      package = mkOption {
        type = types.package;
        default = shell-default;
        description = "The package of Caelestia shell";
      };
      systemd = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable the systemd service for Caelestia shell";
        };
        target = mkOption {
          type = types.str;
          description = ''
            The systemd target that will automatically start the Caelestia shell.
          '';
          default = config.wayland.systemd.target;
        };
        environment = mkOption {
          type = types.listOf types.str;
          description = "Extra Environment variables to pass to the Caelestia shell systemd service.";
          default = [ ];
          example = [
            "QT_QPA_PLATFORMTHEME=gtk3"
          ];
        };
      };
      baseColors = mkOption {
        type = types.nullOr (types.attrsOf types.str);
        default = null;
        description = "Base theme colors (accent, accent2, background, surface, surfaceAlt, text, muted, border, shadow). Automatically derived into a full M3 palette at build time.";
        example = {
          accent = "#d47fa6";
          accent2 = "#e3b17a";
          background = "#0f1117";
          surface = "#191b21";
          surfaceAlt = "#13141a";
          text = "#e6e3e8";
          muted = "#b3adb9";
          border = "#2a2d36";
          shadow = "#000000";
        };
      };
      themeColors = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = "Override individual M3 palette colors. Applied on top of colors derived from baseColors.";
      };
      settings = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Caelestia shell settings";
      };
      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Caelestia shell extra configs written to shell.json";
      };
      cli = {
        enable = mkEnableOption "Enable Caelestia CLI";
        package = mkOption {
          type = types.package;
          default = cli-default;
          description = "The package of Caelestia CLI"; # Doesn't override the shell's CLI, only change from home.packages
        };
        settings = mkOption {
          type = types.attrsOf types.anything;
          default = { };
          description = "Caelestia CLI settings";
        };
        extraConfig = mkOption {
          type = types.str;
          default = "";
          description = "Caelestia CLI extra configs written to cli.json";
        };
      };
    };
  };

  config =
    let
      cli = cfg.cli.package;
      derivedColors = if cfg.baseColors != null then colorLib.deriveM3Palette cfg.baseColors else { };
      finalColors = derivedColors // cfg.themeColors;
      shell =
        if finalColors != { } then cfg.package.override { themeColors = finalColors; } else cfg.package;
    in
    lib.mkIf cfg.enable {
      systemd.user.services.caelestia = lib.mkIf cfg.systemd.enable {
        Unit = {
          Description = "Caelestia Shell Service";
          After = [ cfg.systemd.target ];
          PartOf = [ cfg.systemd.target ];
          X-Restart-Triggers = lib.mkIf (cfg.settings != { }) [
            "${config.xdg.configFile."caelestia/shell.json".source}"
          ];
        };

        Service = {
          Type = "exec";
          ExecStart = "${shell}/bin/caelestia-shell";
          Restart = "on-failure";
          RestartSec = "5s";
          TimeoutStopSec = "5s";
          Environment = [
            "QT_QPA_PLATFORM=wayland"
          ]
          ++ cfg.systemd.environment;

          Slice = "session.slice";
        };

        Install = {
          WantedBy = [ cfg.systemd.target ];
        };
      };

      xdg.configFile =
        let
          mkConfig =
            c:
            lib.pipe (if c.extraConfig != "" then c.extraConfig else "{}") [
              builtins.fromJSON
              (lib.recursiveUpdate c.settings)
              builtins.toJSON
            ];
          shouldGenerate = c: c.extraConfig != "" || c.settings != { };
        in
        {
          "caelestia/shell.json" = lib.mkIf (shouldGenerate cfg) {
            text = mkConfig cfg;
          };
          "caelestia/cli.json" = lib.mkIf (shouldGenerate cfg.cli) {
            text = mkConfig cfg.cli;
          };
        };

      home.packages = [ shell ] ++ lib.optional cfg.cli.enable cli;

      home.activation.cleanCaelestiaScheme = lib.mkIf (finalColors != { }) (
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          rm -f "$HOME/.local/state/caelestia/scheme.json"
        ''
      );
    };
}
