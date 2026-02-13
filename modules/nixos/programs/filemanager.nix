{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.programs.filemanager;
in
{
  options.mySystem.programs.filemanager = {
    enable = lib.mkEnableOption "Thunar file manager";
  };

  config = lib.mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    programs.xfconf.enable = true;

    services.gvfs.enable = true;
    services.tumbler.enable = true;
    services.udisks2.enable = true;
  };
}
