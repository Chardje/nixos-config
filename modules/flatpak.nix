{ config, pkgs, ... }:
let

in
{
  services.flatpak = {
    enable = true;
    package = pkgs.flatpak;
  };

}
