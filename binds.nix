{
  config,
  inputs,
  pkgs,
  ...
}:

{
  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "foot";
      "$fileManager" = "nemo";
      "$browser" = "firefox";
      "$menu" = "wofi";
      "$screenshot" = "satty";
      "$emojiPicker" = "wofi-emoji";
      "$audioControl" = "pavucontrol";

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizeactive"
      ];
      bind = [
        # Submap and global setup
        # ", exec, hyprctl dispatch submap global"
        # ", submap, global"

        # Launcher
        "Super, SPACE, exec, caelestia shell drawers toggle launcher"

        # "Super, catchall, exec, caelestia-shell launcherInterrupt" # catchall не можна поза submap
        "Super, mouse:272, exec, caelestia-shell launcherInterrupt"
        "Super, mouse:273, exec, caelestia-shell launcherInterrupt"
        "Super, mouse:274, exec, caelestia-shell launcherInterrupt"
        "Super, mouse:275, exec, caelestia-shell launcherInterrupt"
        "Super, mouse:276, exec, caelestia-shell launcherInterrupt"
        "Super, mouse:277, exec, caelestia-shell launcherInterrupt"
        "Super, mouse_up, exec, caelestia-shell launcherInterrupt"
        "Super, mouse_down, exec, caelestia-shell launcherInterrupt"

        # Misc (видалити/закоментувати якщо dispatcher не існує)
        "Super, ESC, exec, caelestia shell drawers toggle session"
        "Super, del, exec, caelestia shell notifs clear"
        #"$kbShowPanels,, exec, caelestia shell showall"

        # Restore lock
        "Super, L , exec, caelestia shell lock lock"

        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"

        # Media
        "Ctrl Super, Space, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        "Ctrl Super, Equal, exec, playerctl next"
        ", XF86AudioNext, exec, playerctl next"
        "Ctrl Super, Minus, exec, playerctl previous"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioStop, exec, playerctl stop"

        # Kill/restart
        "Ctrl Super Shift, R, exec, hyprctl reload"
        # "Ctrl Super Alt, R, exec, qs -c caelestia kill; caelestia shell -d"

        # Go to workspace #
        "Super, 1, workspace, 1"
        "Super, 2, workspace, 2"
        "Super, 3, workspace, 3"
        "Super, 4, workspace, 4"
        "Super, 5, workspace, 5"
        "Super, 6, workspace, 6"
        "Super, 7, workspace, 7"
        "Super, 8, workspace, 8"
        "Super, 9, workspace, 9"
        "Super, 0, workspace, 10"

        # Go to workspace group #
        # ...repeat for group workspaces if потрібно...

        # Go to workspace -1/+1
        "Super, mouse_down, workspace, -1"
        "Super, mouse_up, workspace, +1"
        "Super, Page_Up, workspace, -1"
        "Super, Page_Down, workspace, +1"
        "Super, A, workspace, -1"
        "Super, D, workspace, +1"
        # Go to workspace group -1/+1
        # "Ctrl Super, mouse_down, workspace, -10"
        # "Ctrl Super, mouse_up, workspace, +10"

        # Toggle special workspace
        # "$kbToggleSpecialWs, exec, caelestia shell toggle specialws"

        # Move window to workspace #
        "Super Shift, 1, movetoworkspace, 1"
        "Super Shift, 2, movetoworkspace, 2"
        "Super Shift, 3, movetoworkspace, 3"
        "Super Shift, 4, movetoworkspace, 4"
        "Super Shift, 5, movetoworkspace, 5"
        "Super Shift, 6, movetoworkspace, 6"
        "Super Shift, 7, movetoworkspace, 7"
        "Super Shift, 8, movetoworkspace, 8"
        "Super Shift, 9, movetoworkspace, 9"
        "Super Shift, 0, movetoworkspace, 10"
        "Super Shift, A, movetoworkspace, -1"
        "Super Shift, D, movetoworkspace, +1"

        # Move window to workspace group #
        # ...repeat for group workspaces if потрібно...

        # Move window to workspace -1/+1
        "Super Alt, Page_Up, movetoworkspace, -1"
        "Super Alt, Page_Down, movetoworkspace, +1"
        "Super Alt, mouse_down, movetoworkspace, -1"
        "Super Alt, mouse_up, movetoworkspace, +1"
        "Ctrl Super Shift, right, movetoworkspace, +1"
        "Ctrl Super Shift, left, movetoworkspace, -1"

        # Move window to/from special workspace
        "Ctrl Super Shift, up, movetoworkspace, special:special"
        "Ctrl Super Shift, down, movetoworkspace, e+0"
        "Super Alt, S, workspace, special:special"
        "Super Shift Alt, S, movetoworkspace, special:special"

        # Window groups
        # ...залишити тільки якщо dispatcher існує...

        # Window actions
        "Super, left, movefocus, l"
        "Super, right, movefocus, r"
        "Super, up, movefocus, u"
        "Super, down, movefocus, d"
        "Super Shift, left, movewindow, l"
        "Super Shift, right, movewindow, r"
        "Super Shift, up, movewindow, u"
        "Super Shift, down, movewindow, d"
        "Super, Minus, splitratio, -0.1"
        "Super, Equal, splitratio, 0.1"
        "Super, mouse:272, movewindow"
        "Super, mouse:273, resizeactive"
        "Ctrl Super, Backslash, centerwindow, 1"
        "Ctrl Super Alt, Backslash, resizeactive, exact 55% 70%"
        "Ctrl Super Alt, Backslash, centerwindow, 1"
        # "$kbWindowPip, exec, caelestia shell resizer pip"
        # "$kbPinWindow, exec, caelestia shell pin"
        # "$kbWindowFullscreen, exec, caelestia shell fullscreen 0"
        # "$kbWindowBorderedFullscreen, exec, caelestia shell fullscreen 1"
        # "$kbToggleWindowFloating, exec, caelestia shell togglefloating"
        "Super, C, killactive"
        "Super, F, fullscreen"        
        "Super, X, togglefloating"
        "Super, P, pin"
        "Super, T, pseudo"
        "Super, J, togglesplit, orientation"

        # Special workspace toggles
        # ...закоментовано, якщо dispatcher не існує...

        # Apps
        "Super, Q, exec, $terminal"
        "Super, W, exec, $browser"
        "Super, E, exec, $fileManager"
        "Ctrl Alt, V, exec, $audioControl"


        # Clipboard and emoji picker
        "Super, V, exec, sh -c 'pkill fuzzel || cliphist list | fuzzel | xargs wl-copy'"
        "Super Alt, V, exec, sh -c 'pkill fuzzel || cliphist list | fuzzel | xargs wl-copy'"
        "Super, Period, exec, sh -c 'pkill fuzzel || wofi-emoji'"
        "Ctrl Shift Alt, V, exec, sh -c 'sleep 0.5s && ydotool type -d 1 \"$(cliphist list | head -1 | cliphist decode)\"'"
        # Utilities
        ", Print, exec, sh -c 'grim - | wl-copy'"
        "Super Shift, S, exec, sh -c 'grim -g \"$(slurp)\" - | wl-copy'"
        #"Super Alt, R, exec, sh -c 'wf-recorder -a'"
        "Ctrl Alt, R, exec, sh -c 'pkill wf-recorder'" # kill recording
        "Super Alt, R, exec, sh -c 'wf-recorder -g \"$(slurp)\" -f ~/videos/recording-$(date +%F-%T).mp4'"

        # Volume
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "Super Shift, M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

        # Sleep
        "Super Shift, L, exec, systemctl suspend-then-hibernate"

        # Clipboard and emoji picker
        "Super, V, exec, sh -c 'pkill fuzzel || cliphist list | fuzzel | xargs wl-copy'"
        "Super, Period, exec, sh -c 'pkill fuzzel || wofi-emoji'"
        "Ctrl Shift Alt, V, exec, sh -c 'sleep 0.5s && ydotool type -d 1 \"$(cliphist list | head -1 | cliphist decode)\"'"

        # Testing
        # "Super Alt, f12, exec, notify-send -u low -i dialog-information-symbolic 'Test notification' \"Here's a really long message to test truncation and wrapping\nYou can middle click or flick this notification to dismiss it!\" -a 'Shell' -A \"Test1=I got it!\" -A \"Test2=Another action\""
        
      ];
    };
  };
}
