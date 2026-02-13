{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.programs.fonts;
in
{
  options.mySystem.programs.fonts = {
    enable = lib.mkEnableOption "Font configuration";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      font-awesome
      nerd-fonts.jetbrains-mono
    ];
  };
}
