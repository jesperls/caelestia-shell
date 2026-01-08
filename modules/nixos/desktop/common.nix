{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.dconf.enable = true;

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  xdg.mime.enable = true;
}
