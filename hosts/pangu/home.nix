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
    ../../modules/home-manager/bundle.nix
  ];

  home.stateVersion = osConfig.mySystem.system.stateVersion;
}
