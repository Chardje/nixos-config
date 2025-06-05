{config,pkgs,lib,...}:

{
  stylix = {
  enable = true;
  targets.gnome.enable = lib.mkDefault false;
  # Приклад налаштувань:
  image = .walls/a_clouds_in_the_sky.png;

#https://github.com/dharmx/walls/blob/main/nord/a_clouds_in_the_sky.png
#https://github.com/dharmx/walls/blob/main/nord/a_drawing_of_a_wolf_and_a_lion.png
#https://github.com/dharmx/walls/blob/main/nord/a_screenshot_of_a_computer.png
#https://github.com/dharmx/walls/blob/main/nord/a_whale_flying_in_the_sky.png
#https://github.com/dharmx/walls/blob/main/pixel/a_video_game_screen_with_trees_and_bushes.jpg
  #base16Scheme = ./styles-base16/share/themes/catppuccin-mocha.yaml;
  fonts = {
    monospace = {
      package = pkgs.fira-code;
      name = "FiraCode Nerd Font";
    };
    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
  };
};
}