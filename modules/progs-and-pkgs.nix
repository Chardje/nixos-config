{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget     
    neofetch     
    waybar
    # Rice
    plymouth-blahaj-theme
    waypaper
    pkgs.hyprlandPlugins.hyprbars
    xdg-desktop-portal-hyprland
    wayland-utils
    kitty
    wlroots
    wofi
    #blueman-applet
    wl-clip-persist
    kdePackages.dolphin
    networkmanagerapplet     
    discord
    pkgs.betterdiscordctl
    pkgs.rustc
    pkgs.rustup
    pkgs.cargo
    wineWowPackages.stable
    winetricks
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    obsidian
    krita
    firefox
    vscode
    tree
    pkgs.unzip
    swww
    foot
    hypridle
    grim
    slurp
    satty
    wlogout
    brightnessctl
    pamixer
    pwvucontrol
  ];
  services={
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
