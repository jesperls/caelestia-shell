{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    nixfmt-tree
    nil
    vscode
    uv
    python314
    nodejs
    dbeaver-bin
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
    aria2

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
    gimp
    prismlauncher
    qbittorrent
    antigravity
    ungoogled-chromium
    via
    helix

    # === File Management ===
    file-roller
    unzip
    zip
    unrar
    evince
    feh
    imv

    # === CUDA ===
    cudaPackages.cudnn
  ];
}
