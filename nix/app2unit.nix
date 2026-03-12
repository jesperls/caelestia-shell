{
  pkgs, # To ensure the nixpkgs version of app2unit
  fetchFromGitHub,
  ...
}:
pkgs.app2unit.overrideAttrs (
  final: prev: rec {
    version = "1.0.3"; # Fix old issue related to missing env var
    src = fetchFromGitHub {
      owner = "Vladimir-csp";
      repo = "app2unit";
      tag = "v${version}";
      hash = "sha256-7eEVjgs+8k+/NLteSBKgn4gPaPLHC+3Uzlmz6XB0930=";
    };
    postFixup = ''
      substituteInPlace $out/bin/app2unit \
        --replace-fail '#!/bin/sh' '#!${pkgs.lib.getExe pkgs.dash}'

      substituteInPlace $out/bin/app2unit \
        --replace-fail 'TERMINAL_HANDLER=xdg-terminal-exec' \
                       'TERMINAL_HANDLER=${pkgs.lib.getExe pkgs.xdg-terminal-exec}'
    '';
  }
)
