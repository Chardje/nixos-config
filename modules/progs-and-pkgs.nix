{
  pkgs,
  inputs,
  lib,
  pkgsStable,
  ...
}:
let
  nur = inputs.nur;
  #mypython = pkgs.python3;
  #.withPackages 
  #(ps: with ps; [ platformio ]);

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
  virtualisation.waydroid.enable = true;
  environment.systemPackages = with pkgs; [
    # Редактори та IDE
    #vim
    qemu
    neovim
    black
    #python312Packages.isort
    rustfmt
    ripgrep
    fd
    tree-sitter
    lua-language-server
    pyright
    nil
    docker-compose
    waydroid
    #blender
    stm32cubemx
    #stm32cubeide
    stlink
    stlink-gui
    stlink-tool
    gcc-arm-embedded
    gnumake
    fastfetch

    # runtimes
    nodejs
    #mypython
    kitty
    #vscode
    vscode-fhs
    #jetbrains.idea-community
    obsidian
    #plantuml
    sops
    pkgs.uwsm

    #pgadmin4-desktopmode
    pkg-config
    wireplumber
    # Веб-браузери та месенджери

    #librewolf
    _64gram
    gpu-screen-recorder-gtk
    vesktop
    signal-desktop

    prismlauncher
    # Файлові менеджери
    nemo

    # Системні утиліти
    ddcutil
    ddccontrol
    #canon-capt
    canon-cups-ufr2
    simple-scan
    talloc
    wget
    tree
    nixfmt
    home-manager
    brightnessctl
    wl-clip-persist
    wayland-utils
    parted
    tparted
    gparted
    SDL2
    gdk-pixbuf # бібліотека іконок
    librsvg # підтримка SVG іконок

    #winboat

    xdg-desktop-portal
    #xdg-desktop-portal-wlr
    pipewire
    crosspipe
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
    peaclock
    kdePackages.kclock
    wlroots
    #swww
    #wlogout
    satty
    git
    #wf-recorder
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
    audacity
    kicad-small
    javaPackages.compiler.openjdk25
    openocd
    (pkgs.writeShellScriptBin "expresslrs-configurator" ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]}:$LD_LIBRARY_PATH"
    exec ${pkgs.expresslrs-configurator}/bin/expresslrs-configurator "$@"
  '')
    platformio
    platformio-core

      # optional: needed as a programmer i.e. for esp32
    avrdude
    usbutils
    dotnetCorePackages.sdk_9_0-bin
    unityhub
    dotnet-sdk
    omnisharp-roslyn
    mono
    msbuild
    netcoredbg
    unity-test
    gnumake
    gcc
    clang
    clang-tools

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

    winbox4

    #shadps4 # ps4 emu
    # Game controller utilities
    SDL2
    SDL2_gfx
    SDL2_mixer
    SDL2_image
    jstest-gtk
    heroic

    # Bluetooth support
    bluez
    bluez-tools
    blueman

    # Some fonts/apps may need overlays or manual packaging if not in nixpkgs

    # Wayland та Hyprland пов’язані пакети
    #waybar
    pkgs.libappindicator-gtk3
    #waypaper
    #pkgs.hyprlandPlugins.hyprbars
    hypridle
    xdg-utils
    grim
    slurp
    #wofi
    foot
    qt5.qtgraphicaleffects

    #syncthing
    syncthingtray
    syncthing

    # Офісні пакети та словники
    #wpsoffice
    libreoffice-fresh
    hunspell
    hunspellDicts.uk_UA
    #onlyoffice-desktopeditors
    hunspell
    hunspellDicts.uk_UA

    # Мультимедіа та графіка
    krita

    #spotify
    # Wine та суміжне
    wineWow64Packages.waylandFull
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

    wakeonlan
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
  services.udev.packages = with pkgs; [ 
    platformio-core.udev
    openocd
  ];
  services.ddccontrol.enable = true;
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox.override {
        extraPolicies = {
          DisableTelemetry = true;
        };
      };
    };
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };
    xwayland.enable = true;
    yazi.enable = true;
    gpu-screen-recorder.enable = true;
    dconf.enable = true;
    obs-studio.enable = true;

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
  hardware.nvidia-container-toolkit.enable = false;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = false;
      setSocketVariable = true; # додає DOCKER_HOST в оточення
    };
  };
}
