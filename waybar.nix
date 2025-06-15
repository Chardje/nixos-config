{ pkgs, lib, host, config, ... }:

{
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [{
      layer = "top";
      position = "top";
      # output = [ "eDP-1" ];

      modules-left = [ "network" "memory" "cpu" "hyprland/window" ];

      modules-center = [ "hyprland/workspaces" ];

      modules-right = [
        "tray"
        "hyprland/language"
        #"custom/language"
        #"battery"
        "backlight"
        "pulseaudio"
        "pulseaudio#microphone"
        "clock"
      ];

      # Workspace module settings
      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        on-click = "activate";
      };

      # Language module settings
      "hyprland/language" = {
        format-en = "en";
        format-uk = "uk";
        on-click = "hyprctl switchxkblayout logitech-usb-receiver next";
        keyboard-name = "logitech-usb-receiver";
      };

      # Tray settings
      tray = {
        icon-size = 13;
        spacing = 10;
      };

      # Clock settings
      clock = {
        format = "| {:%d-%m-%y %a | %H:%M:%S}";
        interval = 1;
        rotate = 0;
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#a6adc8'><b>{}</b></span>";
            weekdays = "<span color='#a6adc8'><b>{}</b></span>";
            today = "<span color='#a6adc8'><b>{}</b></span>";
            days = "<span color='#555869'><b>{}</b></span>";
          };
        };
      };

      "backlight" = {
        format = "backlight {percent}%";
        #format-icons = ["🌑" "🌗" "🌕"];
        on-scroll-up = "brightnessctl set 1%+";
        on-scroll-down = "brightnessctl set 1%-";
        min-length = 6;
      };

      # Battery settings
      # battery = {
      #   format = "{icon} {capacity}%";
      #   format-charging = "🔌 {capacity}%";
      #   format-plugged = "🔌 {capacity}%";
      #   format-icons = ["🔋"];
      #   min-length = 6;

      # };
      # Pulseaudio settings
      "pulseaudio" = {
        format = "{icon} {volume}%";
        tooltip = false;
        format-muted = "vol-mut";
        on-click = "pamixer -t";
        on-scroll-up = "pamixer -i 1";
        on-scroll-down = "pamixer -d 1";
        scroll-step = 5;
        on-click-middle = "pwvucontrol";
        min-length = 6;

        format-icons = {
          #headphone = " ";
          #headset = " ";
          #default = [ " " " " " " "  " ];
          default = "vol";

        };
      };

      # Microphone settings
      "pulseaudio#microphone" = {
        format = "{format_source}";
        format-source = "micro {volume}%";
        format-source-muted = "micro-mut";
        on-click = "pamixer --default-source -t";
        on-scroll-up = "pamixer --default-source -i 5";
        on-scroll-down = "pamixer --default-source -d 5";
        scroll-step = 5;
        on-click-middle = "pwvucontrol";
        min-length = 8;

      };

      # Memory settings
      memory = {
        interval = 10;
        format = "mem {used}GB";
        format-alt = "mem {percentage}%";
      };

      # CPU settings
      cpu = {
        interval = 10;
        format = "cpu {usage}%";
        on-click = "btop";
      };
      # Network settings
      network = {
        tooltip = true;
        format-alt = "net  {essid}";
        format-ethernet = " ";
        tooltip-format = ''
          Network: <big><b>{essid}</b></big>
          Signal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>
          Frequency: <b>{frequency}MHz</b>
          Interface: <b>{ifname}</b>
          IP: <b>{ipaddr}/{cidr}</b>
          Gateway: <b>{gwaddr}</b>
          Netmask: <b>{netmask}</b>'';
        format-linked = " {ifname} (No IP)";
        format-disconnected = " ";
        tooltip-format-disconnected = "Disconnected";
        format-wifi =
          "<span foreground='#99ffdd'>Down {bandwidthDownBytes}</span> <span foreground='#ffcc66'>Up {bandwidthUpBytes}</span>";
        interval = 2;
      };
    }];
    style = builtins.readFile ./waybar.css;
  };
}
