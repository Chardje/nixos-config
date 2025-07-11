# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
let
  #sddm-astronaut = inputs.self.packages.${pkgs.system}.sddm-astronaut;
  #sddm-astronaut =(callPackage ./themes/sddm-astronaut-theme.nix { }).sddm-astronaut;
in {
  system.stateVersion = "25.05";
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/style.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Увімкни Hyprland system-wide
  programs.hyprland.enable = true;

  # Nvidia підтримка (якщо вона є)
  environment.sessionVariables = { WLR_NO_HARDWARE_CURSORS = "1"; };

  nix.settings = {
    max-jobs = 10;
    auto-optimise-store = true;
    substituters =
      [ "https://cache.nixos.org/" "https://chaotic-nyx.cachix.org" ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];

  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vladLinux"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";
  services.xserver.xkb.layout = "us,ua";

  hardware.graphics.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    open = false;

  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  };

  services.displayManager.defaultSession = "hyprland";
  environment.systemPackages = with pkgs; [ pkgs.catppuccin-sddm ];
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  #services.desktopManager.gnome.enable = false;
  #services.displayManager.gdm.enable = false;
  services.xserver.enable = true;

}

