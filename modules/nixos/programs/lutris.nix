{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.programs.lutris;

  lutrisWithDeps = pkgs.lutris.override {
    extraLibraries =
      pkgs: with pkgs; [
        # Audio / media
        libpulseaudio
        pipewire
        openal
        libvorbis
        libogg
        libxkbcommon
        wayland

        # SDL stack (needed by many launchers/installers)
        SDL2
        SDL2_image
        SDL2_mixer
        SDL2_ttf

        # Video / rendering and input helpers
        v4l-utils
        libgudev
        libpng
        libjpeg
        libGL
        libglvnd
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        xorg.libXext
        xorg.libXrandr
        xorg.libXxf86vm
        xorg.libXtst

        # Crypto / TLS and system glue
        openssl
        gnutls
        libgcrypt
        lcms2
        zlib

        # Battle.net / Blizzard launcher dependencies
        freetype
        glib
        openldap
        sqlite
        libgpg-error
        libxml2
        dbus
        cups
        fontconfig
        libunwind
        libxml2
        libopus
        libva

        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav
      ];

    extraPkgs =
      pkgs: with pkgs; [
        wineWowPackages.staging
        winetricks
        gamescope
        mangohud
        gamemode
        dxvk
        vkd3d
        cabextract
        unzip
        p7zip
        vulkan-tools
        protontricks
      ];
  };
in
{
  options.mySystem.programs.lutris = {
    enable = lib.mkEnableOption "Lutris with common gaming dependencies";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };

    environment.systemPackages = [
      lutrisWithDeps
    ];

    # Prevent Wine/DXVK GPU hangs on NVIDIA that can freeze the system
    environment.sessionVariables = {
      # Disable NVIDIA threaded optimizations for Wine (common cause of hangs)
      __GL_THREADED_OPTIMIZATIONS = "0";
      # Wine large address aware — helps with Battle.net memory usage
      WINE_LARGE_ADDRESS_AWARE = "1";
    };
  };
}
