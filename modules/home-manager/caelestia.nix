{
  inputs,
  osConfig,
  ...
}:

let
  colors = osConfig.mySystem.theme.colors;
in

{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    cli.enable = true;

    baseColors = colors;

    settings = {
      appearance = {
        anim.durations.scale = 0.4;
      };
      background.enabled = false;
      paths.wallpaperDir = "~/Pictures/Wallpapers";
      bar.status = {
        showBattery = true;
        showAudio = true;
        showWifi = false;
      };
      border.thickness = 1;
      general = {
        apps.explorer = [ "thunar" ];
        idle = {
          lockBeforeSleep = false;
          timeouts = [ ];
        };
      };
      services.smartScheme = false;
    };
  };
}
