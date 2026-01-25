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
    easyeffects
    espeak

    # === Hardware ===
    solaar
    scrcpy

    # === Applications ===
    inputs.zen-browser.packages.${system}.beta
    obsidian
    libreoffice
    gedit
    mpv
    rhythmbox
    gimp
    prismlauncher
    heroic
    qbittorrent
    antigravity
    protontricks

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
