{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  nur = inputs.nur;
in
{

  fonts.packages = with pkgs; [
    liberation_ttf
    symbola
    wqy_zenhei
    corefonts
    source-han-sans
    source-han-serif
    font-awesome
    fontconfig
    noto-fonts
    noto-fonts-color-emoji
    twemoji-color-font
    unifont
    #material-symbols-font
  ];

  environment.systemPackages = with pkgs; [
    # Редактори та IDE
    vim
    kitty
    vscode
    obsidian
    plantuml
    
    speechd
    #nur.repos.AusCyber.zen-browser

    #pgadmin4-desktopmode
    pkg-config
    wireplumber
    # Веб-браузери та месенджери
    firefox
    #discord
    vesktop
    ayugram-desktop
    #beeper-bridge-manager
    #teams
    teams-for-linux

    # Файлові менеджери
    nemo
    #kdePackages.dolphin

    # Системні утиліти
    ddcutil
    #canon-capt
    canon-cups-ufr2
    simple-scan
    xsane
    sane-airscan
    #python313Packages.python
    #python313Packages.pip
    #python313Packages.psutil
    talloc
    wget
    tree
    nixfmt
    home-manager
    brightnessctl
    networkmanagerapplet
    wl-clip-persist
    wayland-utils
    parted
    tparted
    gparted

    xdg-desktop-portal
    #xdg-desktop-portal-wlr
    pipewire
    helvum
    wireplumber
    (pkgs.writeShellApplication {
      name = "ns";
      checkPhase = "";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })

    wlroots
    swww
    wlogout
    satty
    git
    wf-recorder
    solaar
    logitech-udev-rules
    evtest
    htop

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
    unityhub
    dotnet-sdk
    pkgs.omnisharp-roslyn
    mono
    msbuild
    omnisharp-roslyn
    netcoredbg
    unity-test

    # Icon themes
    hicolor-icon-theme
    adwaita-icon-theme

    # Emoji/symbol picker apps
    gucharmap
    fuzzel
    cliphist
    ydotool
    wl-clipboard
    pavucontrol

    # Network tools
    ethtool
    iproute2
    dnsutils
    inetutils
    speedtest-cli
    curl
    bmon
    tcpdump
    winbox4
    wireguard-ui

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
    #waypaper
    pkgs.hyprlandPlugins.hyprbars
    hypridle
    xdg-utils
    grim
    slurp
    wofi
    foot
    sddm-chili-theme
    libsForQt5.qt5.qtgraphicaleffects

    #syncthing
    syncthingtray
    syncthing

    # Офісні пакети та словники
    wpsoffice
    hunspell
    hunspellDicts.uk_UA

    # Мультимедіа та графіка
    krita

    spotify
    # Wine та суміжне
    wineWowPackages.waylandFull
    winetricks

    (writeScriptBin "wine32" ''
      export WINEARCH=win32
      export WINEPREFIX=$HOME/.wine32
      export WINEDLLOVERRIDES="mscoree,mshtml="
      export MOZ_ENABLE_WAYLAND=1
      wine "$@"
    '')
    (writeScriptBin "winetricks32" ''
      export WINEARCH=win32
      export WINEPREFIX=$HOME/.wine32
      export MOZ_ENABLE_WAYLAND=1
      winetricks "$@"
    '')

    # Ігри
    (modrinth-app.overrideAttrs (oldAttrs: {
      buildCommand = ''
        gappsWrapperArgs+=(
          --set GDK_BACKEND x11
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1
          --set WEBKIT_DISABLE_COMPOSITING_MODE 1
        )
      ''
      + oldAttrs.buildCommand;
    }))

    wakeonlan
    #rpi-imager
    samba
    cifs-utils
  ];
  environment.sessionVariables = {
    "WEBKIT_DISABLE_DMABUF_RENDERER" = "1";
    "WEBKIT_DISABLE_COMPOSITING_MODE" = "1";
    "MOZ_ENABLE_WAYLAND" = "1";
    NIXOS_OZONE_WL = "1";
    T_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
  environment.variables = {
    GTK_THEME = "Catppuccin-Mocha-Dark";
    XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
  };

  networking.networkmanager.enable = true;

  services.matrix-synapse = {

    enable = false;
    settings = {
      server_name = "localhost";
      registration_shared_secret = "mysecret111";

      app_service_config_files = [
        "/home/vlad/.config/bbctl/telegram-registration.yaml"
        "/home/vlad/.config/bbctl/whatsapp-registration.yaml"
        "/home/vlad/.config/bbctl/discord-registration.yaml"
      ];
    };
  };
  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    xwayland.enable = true;
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
