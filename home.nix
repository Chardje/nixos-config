{ lib, inputs, config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./firefox.nix
    #inputs.moonlight.homeModules.default

  ];
  # home.file={
  # "./.local/share/wayland-sessions/hyprland.desktop".text = ''
  # [Desktop Entry]
  # Name=Hyprland
  # Comment=An intelligent dynamic tiling Wayland compositor
  # Exec=Hyprland
  # Type=Application
  # DesktopNames=Hyprland
  # '';
  # ".zshrc".text = ''echo hello home.nix'';
  # }; 

  nixpkgs.overlays =
    [ inputs.nur.overlays.default inputs.nix-alien.overlays.default ];

  home.username = "vlad";
  home.homeDirectory = "/home/vlad";
  home.stateVersion = "25.05";
  services.mpris-proxy.enable = true;
  services.swww.enable = true;
  services.copyq.enable = true;
  services.copyq.forceXWayland = true;
  services.dunst.enable = true;
  services.hyprpolkitagent.enable = true;
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
  xdg.userDirs.templates = "${config.home.homeDirectory}/Templates";
  xdg.userDirs.publicShare = "${config.home.homeDirectory}/Public";
  xdg.userDirs.desktop = "${config.home.homeDirectory}";
  xdg.userDirs.download = "${config.home.homeDirectory}/download";
  xdg.userDirs.documents = "${config.home.homeDirectory}/documents";
  xdg.userDirs.pictures = "${config.home.homeDirectory}/pictures";
  xdg.userDirs.videos = "${config.home.homeDirectory}/videos";
  xdg.userDirs.music = "${config.home.homeDirectory}/music";
  home.preferXdgDirectories = true;

  services.gammastep = {
    enable = true;
    settings = {
      general = {
        adjustment-method = "randr";
        brightness-day = "1.0";
        brightness-night = "0.9";
      };
      manual = {
        lat = "48.4647";
        lon = "35.0462";
      };
      temperature = {
        day = 5500;
        night = 3700;
      };
    };
  };
  #programs.moonlight-mod.enable = true;

  #programs.keepassxc.enable = true;

  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = { exec = "foot"; };
      "org/nemo/desktop" = { show-desktop-icons = false; };
    };
  };

  home.packages = with pkgs; [
    nix-alien
    #dracula-icon-theme
    papirus-icon-theme
  ];
  home.sessionVariables = {
    XDG_DATA_DIRS =
      #"${pkgs.dracula-icon-theme}/share/icons:${pkgs.glib}/share/icons";
      "${pkgs.papirus-icon-theme}/share/icons:${pkgs.glib}/share/icons";
  };

  stylix = {
    #targets.firefox.enable = false;
    enable = true;
    base16Scheme = {
      base00 = "#1d2021"; # background
      base01 = "#303536"; # alt bg
      base02 = "#3c3836"; # border
      base03 = "#434a4c"; # inactive border
      base04 = "#7c6f64"; # tooltip border
      base05 = "#c7ab7a"; # text (inactive)
      base06 = "#ddc7a1"; # text (active)
      base07 = "#d4be98"; # tray
      base08 = "#c14a4a"; # red / alerts
      base09 = "#e78a4e"; # urgent workspace
      base0A = "#d8a657"; # yellow
      base0B = "#a9b665"; # green bg
      base0C = "#89b482"; # cyan
      base0D = "#6c782e"; # dark green
      base0E = "#ea6962"; # magenta
      base0F = "#e78a4e"; # orange
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
    };
  };
  #services.syncthing.enable = true;
  #services.syncthing.settings.relaysEnabled = true;

  # home.pointerCursor = {
  #   name = "graphite-dark-nord";
  #   package = pkgs.graphite-cursors;
  #   size = 24;
  #   gtk.enable = true;
  # };
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;

  };
  programs.foot = { enable = true; };

  programs.home-manager.enable = true;
  programs.floorp.enable = true;
  programs.mangohud.enable = true;

  programs.wofi.enable = true;
  programs.wofi.settings = {
    show = "drun";
    allow_images = true; # Display application icons
    term =
      "${pkgs.foot}/bin/foot"; # Terminal to run commands (adjust as needed)
    width = 600;
    height = 400;
    allow_markup = true;
    exec_search = true;
    insensitive = true;
    sort_order = "alphabrtical";
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting = { enable = true; };
    history = {
      share = true;
      ignoreDups = true;
    };
  };
}
