{ config, pkgs, ... }:

{
  users.users.vlad = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "seat" "docker" "plugdev" "dialout" ]; # Enable ‘sudo’ for the user.
  };
 services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666", GROUP="users"
  '';

  users.users.root = {};

  users.groups.nixbld = {};

  nix.settings.build-users-group = "nixbld";
}