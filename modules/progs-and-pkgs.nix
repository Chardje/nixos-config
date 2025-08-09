{ pkgs, ... }:

{
  imports = [
    ./python.nix
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

    # Веб-браузери та месенджери
    firefox
    discord
    ayugram-desktop

    # Файлові менеджери
    nemo
    kdePackages.dolphin

    # Системні утиліти
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
    pip

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
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA

    # Мультимедіа та графіка
    krita
    spotify
    # Wine та суміжне
    wineWowPackages.stable
    winetricks

    # Ігри
    # (pkgs.modrinth-app.overrideAttrs (oldAttrs: {
    #   buildCommand = ''
    #     gappsWrapperArgs+=(
    #       --set NIXOS_OZONE_WL 1
    #       --set GDK_BACKEND wayland
    #       --set MOZ_ENABLE_WAYLAND 1
    #       --set XDG_SESSION_TYPE wayland
    #       --set ELECTRON_OZONE_PLATFORM_HINT wayland
    #       --set QT_QPA_PLATFORM wayland
    #       --set GTK_THEME Adwaita
    #     )
    #   '' + oldAttrs.buildCommand;
    # }))

    # Інше
    #pkgs.betterdiscordctl
  ];
  services = {
    xserver.enable = true;
    seatd.enable = true;
  };
  programs = {
    hyprland.enable = true;
    yazi.enable = true;
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
