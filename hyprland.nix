{ config, inputs, pkgs, ... }:

{

  #programs.hyprland.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "exec-once" = [
        #"kitty "
        "code"
        "firefox"
        "waypaper --restore"
        "waybar"
        #"blueman-applet"
        "copyq --start-server"
        "wl-clip-persist --clipboard regular"
      ];
      # Monitor configuration
      "monitor" = ",preferred,auto,auto";

      # Environment variables
      "env" = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "WLR_NO_HARDWARE_CURSORS,1"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
      ];

      # General look and feel
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 1;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Window rules
      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
      "$mod" = "SUPER";
      "$terminal" = "foot";
      "$fileManager" = "dolphin";
      "$browser" = "firefox";
      "$menu" = "wofi";
      "$screenshot" = "satty";
      misc = {
        vfr = false;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };
      input = {
        kb_layout = "us,ua";
        kb_options = "grp:alt_shift_toggle";
        numlock_by_default = true;
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 2;
      };
      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizeactive" ];
      bind = import ./binds.nix;
    };
  };
  wayland.windowManager.hyprland.plugins = [

  ];
}
