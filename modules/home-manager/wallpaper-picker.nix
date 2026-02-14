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
      accent2 = colors.accent2;
      background = colors.background;
      surface = colors.surface;
      surfaceAlt = colors.surfaceAlt;
      text = colors.text;
      muted = colors.muted;
      border = colors.border;
      shadow = colors.shadow;
      inherit rounding;
    };
  };
}
