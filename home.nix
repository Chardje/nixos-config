{
  lib,
  #inputs,
  config,
  pkgs,
  ...
}:

{
  programs.home-manager.enable = true;
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./firefox.nix
    #inputs.moonlight.homeModules.default
  ];
  
home.file={
  "./.local/share/wayland-sessions/hyprland.desktop".text = ''
  [Desktop Entry]
  Name=Hyprland
  Comment=An intelligent dynamic tiling Wayland compositor
  Exec=Hyprland
  Type=Application
  DesktopNames=Hyprland
  '';
  ".zshrc".text = ''echo hello home.nix''
}; 

  #nixpkgs.overlays = [
  #  inputs.nur.overlays.default
  #  inputs.nix-alien.overlays.default
  #];
  
  home.username = "vlad";
  home.homeDirectory = "/home/vlad";
  home.stateVersion = "25.05";
  services.mpris-proxy.enable = true;
  services.swww.enable = true;
  services.copyq.enable = true;
  services.copyq.forceXWayland = true;
  services.dunst.enable = true;
  services.hyprpolkitagent.enable = true;
  services.gammastep.enable = true;
  services.gammastep.tray = true;
  services.gammastep.provider = "geoclue2";
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
  xdg.userDirs.templates = null;
  xdg.userDirs.publicShare = null;
  xdg.userDirs.desktop = "${config.home.homeDirectory}";
  xdg.userDirs.download = "${config.home.homeDirectory}/download";
  xdg.userDirs.documents = "${config.home.homeDirectory}/documents";
  xdg.userDirs.pictures = "${config.home.homeDirectory}/pictures";
  xdg.userDirs.videos = "${config.home.homeDirectory}/videos";
  xdg.userDirs.music = "${config.home.homeDirectory}/music";
  home.preferXdgDirectories = true;


  #programs.moonlight-mod.enable = true;

  #programs.keepassxc.enable = true;
  
  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "foot";
      };
      "org/nemo/desktop" = {
      show-desktop-icons = false;
      };
    };
  };


  home.packages = with pkgs; [
  nix-alien
  ];

  stylix = {
    
  	iconTheme.enable = true;
  	iconTheme.package = pkgs.dracula-icon-theme;		
  	iconTheme.dark = "Dracula";
  	targets.firefox = {
  			enable = true;
  			#colorTheme.enable = true;
  			#profileNames = [ "profile_0" ];
  			};
  	};

  #services.syncthing.enable = true;
  #services.syncthing.settings.relaysEnabled = true;

  home.pointerCursor = {
  			name = "graphite-dark-nord";
  			package = pkgs.graphite-cursors;
			size = 24;
  			gtk.enable = true;
  		};

  programs.foot = {
            enable = true;
        };

  programs.home-manager.enable = true;
  programs.floorp.enable = true;
  programs.mangohud.enable = true;

  programs.wofi.enable = true;
  programs.wofi.settings = {
    show = "drun";
    allow_images = true; # Display application icons
    term = "${pkgs.foot}/bin/foot"; # Terminal to run commands (adjust as needed)
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
    syntaxHighlighting = {
      enable = true;
    };
    history = {
      share = true;
      ignoreDups = true;
    };
  };
}