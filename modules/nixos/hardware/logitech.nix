{
  config,
  lib,
  ...
}:

let
  cfg = config.mySystem.hardware.logitech;
in
{
  options.mySystem.hardware.logitech = {
    enable = lib.mkEnableOption "Logitech wireless peripherals support";
  };

  config = lib.mkIf cfg.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
