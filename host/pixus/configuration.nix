{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  nixpkgs = inputs.nixpkgs;
in
{
  nixpkgs.config = {
    allowBroken = false;
    allowUnfree = true;
  };

  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
    "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  # ISO image configuration
  isoImage = {
    isoName = "pixus-nixos.iso";
    volumeID = "PIXUS_NIXOS";
    makeEfiBootable = true;
    makeBiosBootable = true;
    makeUsbBootable = true;
    contents = [
      {
        source = pkgs.writeText "install.sh" ''
          #!/usr/bin/env bash
          set -euo pipefail

          # Mount target system
          mount /dev/disk/by-label/nixos /mnt
          mkdir -p /mnt/boot
          mount /dev/disk/by-label/boot /mnt/boot

          # Generate and install
          nixos-generate-config --root /mnt
          nixos-install --no-root-passwd --flake "path:/etc/nixos#pixus"
        '';
        target = "install.sh";
      }
    ];
  };

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_6;

    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        devices = [ ];
        useOSProber = false;
        extraConfig = "insmod all_video";
        extraInstallCommands = ''
          grub-install --target=i386-efi --efi-directory=/boot --bootloader-id=NixOS --recheck
        '';
      };
    };
    supportedFilesystems = [
      "vfat"
      "ext4"
      "ntfs"
    ];

    kernelParams = [
      "intel_idle.max_cstate=1"
      "i915.force_probe=*"
    ];

    initrd.availableKernelModules = [
      "i915" # Intel graphics
      "usbhid" # USB HID devices
      "usb_storage" # USB storage
      "cdc_acm" # 3G modem
    ];

    extraModulePackages = [ ];
  };

  networking = {
    hostName = "pixus";
    networkmanager.enable = true;
    networkmanager.ensureProfiles = {
      environmentFiles = [ "/etc/nixos/wifi.env" ];
      profiles = {
        home = {
          connection.id = "home";
          connection.type = "wifi";
          wifi.ssid = "@SSID@";
          wifi.mode = "infrastructure";
          wifi-security.key-mgmt = "wpa-psk";
          wifi-security.psk = "@WIFI_PASSWORD@";
          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };
    };
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver

      ];
    };
    firmware = with pkgs; [
      linux-firmware
      #rtl8723bs-firmware
    ];
    bluetooth.enable = true;
    enableAllFirmware = true;

    # PipeWire замість PulseAudio
    pulseaudio.enable = false;

  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "intel" ];
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;

      libinput.enable = true;

      xkb.layout = "us,ua";
      xkb.options = "grp:alt_shift_toggle";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    firefox

    kdePackages.plasma-workspace
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.kate
    kdePackages.plasma-systemmonitor

    maliit-keyboard # заміна plasma-virtual-keyboard
    modemmanager
    usbutils
  ];

  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "uk_UA.UTF-8";
  console.keyMap = "ua";

  users.users.vlad = {
    isNormalUser = true;
    password = "1234";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
  };

  # Налаштування для економії місця на диску 32GB
  nix.settings = {
    auto-optimise-store = true; # Автоматична дедуплікація
    max-free = lib.mkDefault (3 * 1024 * 1024 * 1024); # 3GB вільного місця
    min-free = lib.mkDefault (1 * 1024 * 1024 * 1024); # 1GB мінімум
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d"; # Видаляти старі версії після 14 днів
  };

  # Обмеження кількості генерацій завантаження
  boot.loader.grub.configurationLimit = 5;

    system.stateVersion = "25.05";
}
