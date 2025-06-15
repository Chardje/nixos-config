{ pkgs, inputs, config, ... }: {

  stylix = {

    enable = true;

    autoEnable = true;

    polarity = "dark";

    # Основна палітра
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
    targets = {
      gnome.enable = false;
      qt.enable = false;
    };

    #		cursor = {
    #			name = "graphite-dark-nord";
    #			package = pkgs.graphite-cursors;
    #			size = 24;
    #		};
    
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
    };
  };
}
