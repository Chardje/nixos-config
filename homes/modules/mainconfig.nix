{config,pkgs,...}:
let

in
{
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

  systemd.user.services = {
    "plantuml" = {
      # Атрибути для секції [Unit]
      Unit = {
        Description = "PlantUML Local Server";
        After = [ "network.target" ];
      };

      # Атрибути для секції [Service]
      Service = {
        ExecStart = "${pkgs.plantuml}/bin/plantuml -picoweb -port 8888";
        Restart = "always";
        RestartSec = 5;
      };

      # Атрибути для секції [Install]
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}