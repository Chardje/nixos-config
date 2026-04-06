{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./binds.nix
  ];
  home.packages = [
    pkgs.ranger
    pkgs.sway-contrib.grimshot
    pkgs.pavucontrol
    pkgs.pulsemixer
    pkgs.mpvpaper

    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      "exec-once" = [
        "code"
        "wl-clip-persist --clipboard regular"
        "mpvpaper -o \"loop --no-audio --panscan=1\" -f  '*' ~/Images/pixel-lofi-city-moewalls-com.mp4"
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

    };
  };

  wayland.windowManager.hyprland.plugins = [

  ];
}
