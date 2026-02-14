{
  inputs,
  osConfig,
  ...
}:

let
  colors = osConfig.mySystem.theme.colors;
  rounding = osConfig.mySystem.theme.rounding;
in

{
  imports = [ inputs.quickshell-package-manager.homeManagerModules.default ];

  programs.quickshellPackageManager = {
    enable = true;
    packagesFile = "~/nixos-config/modules/home-manager/packages.nix";
    channel = "nixos-unstable";
    rebuildAlias = "nh os switch ~/nixos-config";
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
      scrollbar = colors.muted;
      button = colors.accent;
      buttonDisabled = colors.surfaceAlt;
      inherit rounding;
    };
  };
}
