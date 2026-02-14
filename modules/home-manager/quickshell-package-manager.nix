{
  inputs,
  ...
}:

{
  imports = [ inputs.quickshell-package-manager.homeManagerModules.default ];

  programs.quickshellPackageManager = {
    enable = true;
    packagesFile = "~/nixos-config/modules/home-manager/packages.nix";
    channel = "nixos-unstable";
    rebuildAlias = "nh os switch ~/nixos-config";
  };
}
