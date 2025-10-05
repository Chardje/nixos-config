# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let

in
{
  system.stateVersion = "25.05";
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./modules/style.nix
    ./modules/progs-and-pkgs.nix

  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = lib.mkForce true;
  };

  fileSystems."/home/vlad/smb/Shared" = {
    device = "//192.168.88.2/Shared";
    fsType = "cifs";
    options = [
      "username=pi"
      "password=qwerty"
      "rw"
      "uid=1000"
      "gid=1000"
    ];
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
    substituters = [
      "https://cache.nixos.org/"
      "https://chaotic-nyx.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];

  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [
    "i2c-dev"
    "i2c-core"
    "i2c-i801"
  ];

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
  services.printing.drivers = with pkgs; [
    gutenprint
    canon-cups-ufr2 
    #canon-capt
  ];

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [ sane-airscan ];
  };

  services.syncthing = {
    enable = true;
    user = "vlad";
    dataDir = "/home/vlad/Sync/obsidian"; # куди зберігати дані
    configDir = "/home/vlad/.config/syncthing"; # де конфіг
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.xserver.enable = true;

  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  '';

  # Дає користувачу vlad доступ до пристроїв яскравості
  services.udev.extraRules = ''
    SUBSYSTEM=="backlight", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    SUBSYSTEM=="backlight", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  users.users.vlad = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "plugdev"
      "bluetooth"
      "networkmanager"
      "i2c"
      "video"
    ];
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  xdg.mime = {
    enable = true;
    defaultApplications = {
      # Текстові та програмні файли
      "text/plain" = "code.desktop";
      "application/json" = "code.desktop";
      "application/xml" = "code.desktop";
      "application/x-python" = "code.desktop";
      "application/x-shellscript" = "code.desktop";
      "text/x-csrc" = "code.desktop";
      "text/x-c++src" = "code.desktop";
      "text/x-java" = "code.desktop";
      "text/x-go" = "code.desktop";
      "text/x-rust" = "code.desktop";
      "text/x-markdown" = "code.desktop";
      # PDF
      "application/pdf" = "wpspdf.desktop";
      # Офісні документи
      "application/msword" = "wps-office.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "wps-office.desktop";
      "application/vnd.ms-excel" = "wps-office.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "wps-office.desktop";
      "application/vnd.ms-powerpoint" = "wps-office.desktop";
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "wps-office.desktop";
      # Архіви
      "application/zip" = "xarchiver.desktop";
      "application/x-rar" = "xarchiver.desktop";
      "application/x-7z-compressed" = "xarchiver.desktop";
      "application/x-tar" = "xarchiver.desktop";
      "application/gzip" = "xarchiver.desktop";
      "application/x-bzip2" = "xarchiver.desktop";
      "application/x-xz" = "xarchiver.desktop";
      # Зображення
      "image/png" = "feh.desktop";
      "image/jpeg" = "feh.desktop";
      # Аудіо
      "audio/mpeg" = "mpv.desktop";
    };
  };

  # Bluetooth працює через USB-адаптер (Cambridge Silicon Radio, Ltd Bluetooth Dongle)

  services.samba = {
    enable = true;
    settings = {
      shared = {
        path = "~/smb/Shared";
        writable = true;
        browseable = true;
        guestOk = false;
        validUsers = [ "pi" ];
      };
    };
  };
}
