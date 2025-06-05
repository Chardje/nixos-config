{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
{
programs.home-manager.enable = true;
home.username = "vlad";
home.homeDirectory = "/home/vlad";
home.stateVersion = "25.05";
}