{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.mySystem.hardware.webcam;
in
{
  options.mySystem.hardware.webcam = {
    enable = mkEnableOption "v4l2loopback virtual webcam (for phone as webcam via scrcpy)";
    
    videoNumber = mkOption {
      type = types.int;
      default = 2;
      description = "Video device number for the virtual webcam";
    };
    
    cardLabel = mkOption {
      type = types.str;
      default = "Scrcpy Webcam";
      description = "Label for the virtual webcam device";
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    boot.kernelModules = [ "v4l2loopback" ];

    boot.extraModprobeConfig = ''
      options v4l2loopback video_nr=${toString cfg.videoNumber} card_label="${cfg.cardLabel}" exclusive_caps=1
    '';

    environment.systemPackages = [ pkgs.android-tools ];
  };
}
