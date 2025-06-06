{ config, pkgs, lib, ... }:

{
  # Fonts — окремо від stylix
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "FiraCode Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      fira-code
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.iosevka
    ] 
    ;

  };

  stylix = {
    enable = false;
    image = ../walls/a_clouds_in_the_sky.png;

    fonts = {
      monospace.name = "FiraCode Nerd Font";
      sansSerif.name = "Noto Sans";
      serif.name = "Noto Serif";
      emoji.name = "Noto Color Emoji";
    };

    targets = {
      gnome.enable = false;
      qt.enable = false;
    };
  };
}
