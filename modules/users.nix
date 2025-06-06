{ config, pkgs, ... }:

{
  users.users.vlad = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "seat"]; # Enable ‘sudo’ for the user.
  };

  users.users.root = {};

  users.groups.nixbld = {};

  nix.settings.build-users-group = "nixbld";
}