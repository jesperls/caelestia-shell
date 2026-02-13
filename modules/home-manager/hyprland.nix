{
  config,
  pkgs,
  osConfig,
  lib,
  ...
}:

let
  wallpaperManager = pkgs.writeShellApplication {
    name = "wallpaper-manager";
    runtimeInputs = with pkgs; [
      hyprpaper
      hyprland
      jq
      findutils
      coreutils
      imagemagick
      wofi
    ];
    text = builtins.readFile ./scripts/wallpaper-manager.sh;
  };

  hyprSettings = import ./hyprland/settings.nix {
    inherit
      config
      pkgs
      lib
      osConfig
      ;
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = lib.mkMerge [
      (import ./hyprland/variables.nix { })
      hyprSettings.settings
      (import ./hyprland/binds.nix { })
      (import ./hyprland/windowrules.nix { })
    ];
  };

  xdg.configFile."hypr/xdph.conf".text = ''
    screencopy {
      allow_token_by_default = true
    }
  '';

  xdg.configFile."wofi/wallpaper-picker.css".text = import ./hyprland/wallpaper-picker.nix {
    inherit osConfig;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
    };
  };

  home.packages =
    (with pkgs; [
      hyprpicker
    ])
    ++ [ wallpaperManager ];
}
