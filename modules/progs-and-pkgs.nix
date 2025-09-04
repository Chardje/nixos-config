{ pkgs, ... }:

{
  imports = [
    #./python.nix
  ];

  environment.systemPackages = with pkgs; [
    # Редактори та IDE
    vim
    kitty
    vscode
    obsidian
    rustc
    rustup
    cargo
    pgadmin4-desktopmode

    # Веб-браузери та месенджери
    firefox
    #discord
    pkgs.vesktop
    ayugram-desktop
    #teams
    teams-for-linux

    # Файлові менеджери
    nemo
    kdePackages.dolphin

    # Системні утиліти
    python313
    python313Packages.python
    python313Packages.pip
    python313Packages.meshtastic
    wget
    tree
    nixfmt
    home-manager
    brightnessctl
    pamixer
    pwvucontrol
    networkmanagerapplet
    wl-clip-persist
    wayland-utils
    wlroots
    swww
    wlogout
    satty
    git
    wf-recorder
    solaar
    logitech-udev-rules
    evtest

    atool
    xarchiver
    zip
    unzip
    unrar
    p7zip
    gnutar
    gzip
    bzip2
    xz
    p7zip
    zstd
    mpv
    feh
    imv
    vlc

    dotnetCorePackages.sdk_9_0-bin

    # Fonts for formula symbols
    liberation_ttf
    symbola
    wqy_zenhei
    source-han-sans
    source-han-serif
    font-awesome
    fontconfig
    noto-fonts
    noto-fonts-emoji
    twemoji-color-font
    unifont

    # Emoji/symbol picker apps
    gucharmap

    # Network tools
    ethtool
    iproute2
    dnsutils
    inetutils
    speedtest-cli
    curl
    bmon
    tcpdump

    # Game controller utilities
    SDL2
    SDL2_gfx
    SDL2_mixer
    SDL2_image
    jstest-gtk

    # Bluetooth support
    bluez
    bluez-tools
    blueman

    # Some fonts/apps may need overlays or manual packaging if not in nixpkgs

    # Wayland та Hyprland пов’язані пакети
    #waybar
    pkgs.libappindicator-gtk3
    waypaper
    pkgs.hyprlandPlugins.hyprbars
    xdg-desktop-portal-hyprland
    hypridle
    grim
    slurp
    wofi
    foot
    sddm-chili-theme
    libsForQt5.qt5.qtgraphicaleffects

    # Темізація / Рис
    #plymouth-blahaj-theme

    # Офісні пакети та словники
    wpsoffice
    hunspell
    hunspellDicts.uk_UA

    # Мультимедіа та графіка
    krita
    spotify
    # Wine та суміжне
    wineWowPackages.stable
    winetricks

    # Ігри
    (modrinth-app.overrideAttrs (oldAttrs: {
      buildCommand = ''
        gappsWrapperArgs+=(
          --set GDK_BACKEND x11
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1
          --set WEBKIT_DISABLE_COMPOSITING_MODE 1
        )
      '' + oldAttrs.buildCommand;
    }))

    # Інше
    #pkgs.betterdiscordctl
  ];
  environment.sessionVariables = {
    "WEBKIT_DISABLE_DMABUF_RENDERER" = "1";
    "WEBKIT_DISABLE_COMPOSITING_MODE" = "1";
  };
  environment.variables = { GTK_THEME = "Catppuccin-Mocha-Dark"; };

  services = {
    xserver.enable = true;
    seatd.enable = true;
  };

  networking.networkmanager.enable = true;

  programs = {
    hyprland.enable = true;
    yazi.enable = true;
    gpu-screen-recorder.enable = true;

    java = {
      enable = true;
      package = pkgs.jdk21;
    };
    steam.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    git.enable = true;
  };

  virtualisation.docker.enable = true;
}
