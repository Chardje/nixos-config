# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
let

in {
  system.stateVersion = "25.05";
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./modules/style.nix
    ./modules/progs-and-pkgs.nix

  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = lib.mkForce true;
  };

  # Увімкни Hyprland system-wide
  programs.hyprland.enable = true;

  # Додаємо Caelestia shell до системних пакетів
  environment.systemPackages = with pkgs; [
    helvum
    # pkgs.caelestia-shellda
  ];

  # Nvidia підтримка (якщо вона є)
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

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

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";
  services.xserver.xkb.layout = "us,ua";

  hardware.graphics.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
  };


  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Використовуємо Hyprland як сесію для входу (Caelestia shell стартує через Home Manager/systemd user)
  services.displayManager.defaultSession = "hyprland";
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    #wayland.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.xserver.enable = true;

  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  '';

     

  users.users.vlad = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "plugdev" "bluetooth" "networkmanager" ];
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Bluetooth працює через USB-адаптер (Cambridge Silicon Radio, Ltd Bluetooth Dongle)
}

