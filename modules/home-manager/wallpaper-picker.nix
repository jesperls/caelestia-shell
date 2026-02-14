{
  inputs,
  osConfig,
  lib,
  ...
}:

let
  colors = osConfig.mySystem.theme.colors;
  rounding = osConfig.mySystem.theme.rounding;
in
{
  imports = [ inputs.wallpaper-picker.homeManagerModules.default ];

  programs.wallpaperPicker = {
    enable = true;
    theme = {
      accent = colors.accent;
      background = colors.background;
      surface = colors.surface;
      text = colors.text;
      muted = colors.muted;
      border = colors.border;
      inherit rounding;
    };
  };
}
