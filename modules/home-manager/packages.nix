{
  pkgs,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  # Environment variables to help uv work properly on NixOS
  home.sessionVariables = {
    # Tell uv to use the system Python as a fallback and help with linking
    UV_PYTHON_PREFERENCE = "managed";
    # Ensure pip/uv can find SSL certificates
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    # Help compiled extensions find libraries
    LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:/run/current-system/sw/lib";
  };

  home.packages = with pkgs; [
    git
    gh
    nixfmt
    nil
    vscode
    uv
    python314
    nodejs
    dbeaver-bin
    cudaPackages.cudnn

    nh
    jq
    yq
    fd
    ripgrep
    bat
    xdg-utils
    htop
    btop
    ncdu
    p7zip
    parted
    yt-dlp
    playerctl
    inputs.deltatune.packages.${system}.default

    grim
    slurp
    wl-clipboard
    cliphist
    wofi
    gsettings-desktop-schemas
    glib
    wlogout
    networkmanagerapplet
    mission-center

    pavucontrol
    pulseaudio
    qpwgraph
    overskride
    easyeffects

    solaar
    vial

    inputs.zen-browser.packages.${system}.twilight
    vesktop
    obsidian
    libreoffice
    gedit
    mpv
    rhythmbox
    gimp
    prismlauncher
    heroic
    qbittorrent

    file-roller
    unzip
    zip
    unrar
    evince
    feh
    imv
    adwaita-icon-theme

    wineWowPackages.stable
    winetricks
  ];
}
