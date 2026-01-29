{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  # nixpkgs' libcava provides cava.pc but upstream caelestia-shell now expects libcava.pc
  # Create a patched libcava that provides the expected pkg-config name
  libcavaPatched = pkgs.libcava.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      # Create libcava.pc symlink for compatibility with upstream caelestia-shell
      ln -s $out/lib/pkgconfig/cava.pc $out/lib/pkgconfig/libcava.pc
    '';
  });

  # Override the caelestia-shell package to use patched libcava
  caelestiaShellPatched =
    (inputs.caelestia-shell.packages.${system}."with-cli".override {
      libcava = libcavaPatched;
    }).overrideAttrs
      (old: {
        prePatch =
          (old.prePatch or "")
          + ''
            substituteInPlace services/GameMode.qml \
              --replace '"general:border_size": 1' '"general:border_size": 0'
            substituteInPlace services/Notifs.qml \
              --replace 'notif.tracked = true;' 'const app = (notif.appName || "").toLowerCase(); if (app.includes("spotify")) return; notif.tracked = true;'
          '';
      });
in
{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  programs.caelestia = {
    enable = true;
    package = caelestiaShellPatched;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    cli.enable = true;
    settings = {
      appearance = {
        anim = {
          durations = {
            scale = 0.4;
          };
        };
      };
      background = {
        enabled = false;
      };
      paths.wallpaperDir = "~/Pictures/Wallpapers";
      bar.status = {
        showBattery = true;
        showAudio = true;
        showWifi = false;
      };
      general = {
        apps = {
          explorer = [ "thunar" ];
        };
        idle = {
          lockBeforeSleep = false;
          timeouts = [ ];
        };
      };
    };
  };
}
