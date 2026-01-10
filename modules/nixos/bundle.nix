{ ... }:

{
  imports = [
    ./core/boot.nix
    ./core/network.nix
    ./core/nix.nix
    ./core/options.nix
    ./core/locale.nix
    ./core/theme.nix

    ./hardware/nvidia.nix
    ./hardware/vial.nix
    ./hardware/webcam.nix

    ./services/audio.nix
    ./services/bluetooth.nix
    ./services/backup.nix
    ./services/flatpak.nix

    ./programs/gaming.nix
    ./programs/lutris.nix
    ./programs/fonts.nix
    ./programs/filemanager.nix

    ./desktop/common.nix
    ./desktop/hyprland.nix

    ./performance/optimizations.nix

    ./users.nix
  ];
}
