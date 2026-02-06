{
  config,
  lib,
  ...
}:

let
  cfg = config.mySystem.services.flatpak;
in
{
  options.mySystem.services.flatpak = {
    enable = lib.mkEnableOption "Flatpak package manager";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    xdg.portal.enable = true;
  };
}
