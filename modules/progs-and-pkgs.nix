{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget     
    neofetch     
    waybar
    # pkgs.hyprlandPlugins.hyprbars
    wayland-utils
    kitty
    wlroots
    wofi
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
    hunspellDicts.th_TH
    obsidian
    krita
    firefox
    vscode
    tree
    pkgs.unzip
    swww
  ];
  services={
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