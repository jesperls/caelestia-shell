{
  config,
  pkgs,
  osConfig,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/home-manager/environment.nix
    ../../modules/home-manager/xdg.nix
    ../../modules/home-manager/theme.nix
    ../../modules/home-manager/mimeapps.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/cli.nix
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/packages.nix
    ../../modules/home-manager/vesktop.nix
    ../../modules/home-manager/caelestia.nix
    ../../modules/home-manager/spicetify.nix
    ../../modules/home-manager/deltatune.nix
    ../../modules/home-manager/obs.nix
  ];

  home.stateVersion = osConfig.mySystem.system.stateVersion;
}
