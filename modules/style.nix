{config,pkgs,...}:

{
  tylix = {
  enable = true;
  # Приклад налаштувань:
  image = "/etc/nixos/wallpaper.jpg"; # шлях до твого зображення
  base16Scheme = "catppuccin-mocha";
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
};