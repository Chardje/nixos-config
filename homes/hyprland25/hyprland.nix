{

  config,

inputs,

pkgs,

lib,

...

}:

{

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




configType = "lua";




extraLuaFiles = {

config = builtins.readFile ./config.lua;

binds = builtins.readFile ./binds.lua;

    };




plugins = [ ];

  };

}
