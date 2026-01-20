{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.hardware.webcam;
in
{
  options.mySystem.hardware.webcam = {
    enable = lib.mkEnableOption "v4l2loopback virtual webcam (for phone as webcam via scrcpy)";

    videoNumber = lib.mkOption {
      type = lib.types.int;
      default = 2;
      description = "Video device number for the virtual webcam";
    };

    cardLabel = lib.mkOption {
      type = lib.types.str;
      default = "Scrcpy Webcam";
      description = "Label for the virtual webcam device";
    };
  };

  config = lib.mkIf cfg.enable {
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
