{ config, inputs, pkgs, ... }:

{

  #programs.hyprland.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "exec-once" = [
        "kitty "
        "waypaper --restore"
        "waybar"
        #"blueman-applet"
        "copyq --start-server"
        "wl-clip-persist --clipboard regular"

      ];
      "$mod" = "SUPER";
      "$terminal" = "foot";
      "$fileManager" = "dolphin";
      "$browser" = "firefox";
      "$menu" = "wofi";

      #    general = {
      #            gaps_in = 5;
      #            gaps_out = 0;
      #            border_size = 2;
      #            resize_on_border = false;
      #            allow_tearing = false;
      #            layout = "dwindle";
      #          };

      decoration = {
        active_opacity = 1;
        inactive_opacity = 1;
        blur.enabled = false;
        shadow.enabled = false;
      };

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

      #	windowrulev2 = [
      #		#"suppressevent maximize, class:.*"
      #		#"center, floating:1"
      #		"float, class:(foot)"
      #		"float, class:(com.github.hluk.copyq)"
      #		"float, class:(zenity)"
      #		"float, class: com.saivert.pwvucontrol"
      #	];

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 2;
      };

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

      bind = [
        "$mod, X, movetoworkspace, X"

        "$mod, Q, exec, $terminal"
        "$mod, W, exec, $browser"
        "$mod, E, exec, $fileManager"
        "$mod, R, exec, $menu"

        "$mod, C, killactive"
        "$mod, F, togglefloating"
        "$mod, X, pseudo"

        "Shift, Alt_L, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next"

        "Ctrl, Escape, exec, killall $panel || $panel"

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

        "$mod, D, workspace, +1"
        "$mod, A, workspace, -1"

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

        "$mod SHIFT, D, movetoworkspace, +1"
        "$mod SHIFT, A, movetoworkspace, -1"

        #"$mod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
        #"$mod, Z, exec, copyq read $(seq 0 $(( $(copyq count) - 1 ))) 2>/dev/null | wofi --show dmenu | wl-copy"
        "$mod, V, exec, copyq toggle"
        "$mod, ESCAPE, exec, wlogout"

        '', Print, exec, grim -g "$(slurp)" - | satty -f -''
        "Ctrl, Escape, exec, pkill waybar || waybar"

        "$mod, mouse_down, workspace, e-1"
        "$mod, mouse_up, workspace, e+1"

        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
    };
  };
  wayland.windowManager.hyprland.plugins = [

  ];
}
