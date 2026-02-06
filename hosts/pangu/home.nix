{ osConfig, ... }:

{
  imports = [
    ../../modules/home-manager/bundle.nix
  ];

  home.stateVersion = osConfig.mySystem.system.stateVersion;
}
