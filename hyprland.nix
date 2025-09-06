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
      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, W, exec, $browser"
        "$mod, E, exec, $fileManager"
        "$mod, R, exec, $menu"
        "$mod, C, killactive"
        "$mod, F, togglefloating"
        "$mod SHIFT, F, fullscreen"
        "$mod, X, pseudo"
        "$mod, M, exit"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, Z, togglespecialworkspace, magic"
        "$mod SHIFT, Z, movetoworkspace, special:magic"

        "$mod, D, workspace, +1"
        "$mod, A, workspace, -1"
        "$mod SHIFT, D, movetoworkspace, +1"
        "$mod SHIFT, A, movetoworkspace, -1"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        "Shift, Alt_L, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next"
        "Ctrl, Escape, exec, killall $panel || $panel"
        "$mod, V, exec, copyq toggle"
        "$mod, ESCAPE, exec, killall wlogout || wlogout"
        "$mod SHIFT, S, exec, sh -c 'grim -g \"$(slurp)\" - | satty -f -'"
        "Ctrl, Escape, exec, pkill waybar || waybar"

        # Multimedia keys
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
        # Media keys
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
  wayland.windowManager.hyprland.plugins = [

  ];
}
