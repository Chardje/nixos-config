{ pkgs, ... }:

{
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

    # Wayland та Hyprland пов’язані пакети
    waybar
    waypaper
    pkgs.hyprlandPlugins.hyprbars
    xdg-desktop-portal-hyprland
    hypridle
    grim
    slurp
    wofi
    foot

    # Темізація / Рис
    plymouth-blahaj-theme

    # Офісні пакети та словники
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA

    # Мультимедіа та графіка
    krita

    # Wine та суміжне
    wineWowPackages.stable
    winetricks

    # Інше
    pkgs.betterdiscordctl
  ];
  services = {
    xserver.enable = true;
    #xserver.displayManager.lightdm.enable = true;

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
