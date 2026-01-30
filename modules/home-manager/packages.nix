{
  pkgs,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = with pkgs; [
    nixfmt
    nil
    vscode
    uv
    python314
    nodejs
    dbeaver-bin
    git
    ydotool

    # === CLI Utilities ===
    jq
    yq
    fd
    ripgrep
    xdg-utils
    htop
    ncdu
    p7zip
    parted
    yt-dlp
    playerctl
    trash-cli

    # === Screen/Display ===
    grim
    slurp
    wl-clipboard
    cliphist
    wofi

    # === System Integration ===
    gsettings-desktop-schemas
    glib
    wlogout
    networkmanagerapplet
    mission-center

    # === Audio ===
    pavucontrol
    pulseaudio
    qpwgraph
    overskride
    espeak
    audacity
    portaudio
    pkg-config

    # === Hardware ===
    solaar
    scrcpy

    # === Applications ===
    obsidian
    gedit
    mpv
    rhythmbox
    gimp
    prismlauncher
    qbittorrent
    antigravity
    protontricks
    ungoogled-chromium
    via

    # === File Management ===
    file-roller
    unzip
    zip
    unrar
    evince
    feh
    imv

    # === Gaming/Wine ===
    wineWowPackages.stable
    winetricks

    # === CUDA ===
    cudaPackages.cudnn

    # === Custom Packages ===
    inputs.deltatune.packages.${system}.default
  ];
}
