{ lib, ... }:

{
  options.mySystem = {
    # User configuration
    user = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "The username of the primary user.";
      };
      fullName = lib.mkOption {
        type = lib.types.str;
        description = "The full name of the primary user.";
      };
      email = lib.mkOption {
        type = lib.types.str;
        description = "The email of the primary user.";
      };
    };

    # System configuration
    system = {
      locale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        description = "The system locale.";
      };
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Stockholm";
        description = "The system timezone.";
      };
      keyboardLayout = lib.mkOption {
        type = lib.types.str;
        default = "se";
        description = "The keyboard layout.";
      };
      consoleKeyMap = lib.mkOption {
        type = lib.types.str;
        default = "sv-latin1";
        description = "The console key map.";
      };
      extraLocaleSettings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Extra locale settings.";
      };
      hostName = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
        description = "The system hostname.";
      };
      stateVersion = lib.mkOption {
        type = lib.types.str;
        default = "25.05";
        description = "The system state version.";
      };
    };

    # Monitor configuration
    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of monitor configurations for Hyprland.";
    };
  };
}
