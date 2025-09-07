{ lib, inputs, config, pkgs, catppuccinLib, ... }:
let

in {
  imports = [
    ./hyprland.nix
    #./waybar.nix
    ./firefox.nix
    #inputs.moonlight.homeModules.default
    #./small-styles.nix
    inputs.catppuccin.homeModules.catppuccin
    inputs.caelestia-shell.homeManagerModules.default
  ];


  catppuccin.enable = false;
  catppuccin.flavor = "frappe";
  catppuccin.accent = "sapphire";

  catppuccin.waybar = {
    enable = true;
    flavor = "frappe";
    mode = "prependImport"; # or "createLink" if you prefer symlink mode
  };

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

  programs.vscode = {
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      christian-kohler.npm-intellisense
      github.copilot
      github.copilot-chat
      jnoortheen.nix-ide
      ms-azuretools.vscode-docker
      ms-dotnettools.csdevkit
      ms-dotnettools.csharp
      ms-dotnettools.vscode-dotnet-runtime
      ms-python.debugpy
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vsliveshare.vsliveshare
    ];
  };

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
    papirus-icon-theme
    
  ];
  home.sessionVariables = builtins.trace
    "Waybar style file: ${config.xdg.configHome}/waybar/style.css" {
      XDG_DATA_DIRS =
        "${pkgs.papirus-icon-theme}/share/icons:${pkgs.glib}/share/icons";
    };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;

  };

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

  # Приклад використання стилю для foot (шлях, а не readFile)
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=13";
        dpi-aware = "yes";
        pad = "10x10";
        bold-text-in-bright = "yes";
      };
    };
  };

  programs.caelestia = {
    enable = true;
    systemd.enable = true;
    systemd.target = "graphical-session.target";
    settings = {
      bar.status = { showBattery = false; 
      temperatureUnit = "C"; # Додайте цей рядок для використання градусів Цельсія
      showCpu = true;
      showMemory = true;
      showNetwork = true;
      showClock = true;
    };
    dashboard = {
      showWeather = true;
      weatherLocation = "Kyiv,UA";
      weather = {
        temperatureUnit = "C";
      };
      
    };
    perfomance = {
      enableAnimations = true;
      smoothScrolling = true;
      temperatureUnit = "C";
    };
    paths.wallpaperDir = "~/Images";
  };
  cli = {
    enable = true;
    settings = { theme.enableGtk = false; };
    };
  };

  systemd.user.services = {
    "hyprland" = {
      serviceConfig = {
        Description = "Hyprland Session (after Caelestia)";
        ExecStart = "${pkgs.hyprland}/bin/Hyprland";
        Restart = "on-failure";
        After = "caelestia-shell.service";
        Wants = "caelestia-shell.service";
      };
      install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

}