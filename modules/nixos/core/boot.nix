{ pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "quiet"
      "splash"
      "nowatchdog"
      "video=DP-3:2560x1440@240"
      "video=DP-2:2560x1440@144"
      "video=HDMI-A-1:1920x1080@60"
    ];

    plymouth = {
      enable = true;
      theme = "pixels";
      themePackages = [ pkgs.adi1090x-plymouth-themes ];
    };

    consoleLogLevel = 0;

    tmp.useTmpfs = true;
  };

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
}
