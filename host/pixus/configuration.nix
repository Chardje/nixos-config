{ config, pkgs25, lib, ... }:

let
  nixpkgs = pkgs25;
in
{
  nixpkgs.config.allowUnfree = true;

  # === Завантажувач: GRUB (32 + 64 EFI) ===
  boot.loader = {
    systemd-boot.enable = false;
    refind.enable = false;

    grub = {
      enable = lib.mkForce true;
      device = "nodev";           # Для ISO
      efiSupport = true;
      efiInstallAsRemovable = true;
      useOSProber = false;

      # Додаємо 32-бітний EFI
      extraFiles = {
        "efi/boot/bootia32.efi" = "${nixpkgs.grub2}/EFI/boot/bootia32.efi";
      };
    };
  };

  # === ISO ===
  isoImage = {
    isoBaseName = lib.mkForce "pixus-nixos";
    isoName = "pixus-nixos.iso";
    volumeID = "PIXUS_NIXOS";
    makeEfiBootable = true;
    makeUsbBootable = true;
    appendToMenuLabel = " Pixus";

    contents = [
      # GRUB у корені (для BIOS)
      { source = nixpkgs.grub2; target = "/grub2"; }

      # Скрипт встановлення
      {
        source = nixpkgs.writeTextFile {
          name = "install.sh";
          text = ''
            #!/usr/bin/env bash
            set -euo pipefail
            echo "Запуск установки Pixus NixOS..."
            mount /dev/disk/by-label/nixos /mnt || true
            mkdir -p /mnt/boot
            mount /dev/disk/by-label/boot /mnt/boot || true
            nixos-generate-config --root /mnt
            nixos-install --no-root-passwd --flake "path:/etc/nixos#pixus"
            echo "Установка завершена! Перезавантажтеся."
          '';
          executable = true;
        };
        target = "/install.sh";
      }
    ];
  };

  # === Ядро ===
  boot = {
    kernelPackages = lib.mkForce nixpkgs.linuxPackages_6_6;
    supportedFilesystems = [ "vfat" "ext4" "ntfs" ];
    kernelParams = [ "intel_idle.max_cstate=1" "i915.force_probe=*" ];
    initrd.availableKernelModules = [ "i915" "usbhid" "usb_storage" "cdc_acm" ];
  };

  # === Мережа ===
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
          wifi-security.key-mgmt = "wpa-psk";
          wifi-security.psk = "@WIFI_PASSWORD@";
        };
      };
    };
  };

  # === Графіка + Сенсор ===
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with nixpkgs; [ intel-media-driver intel-vaapi-driver ];
    };
    firmware = with nixpkgs; [ linux-firmware ];
    bluetooth.enable = true;
    enableAllFirmware = true;
  };

  # === Дисплей + KDE + Сенсор ===
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "intel" ];
      xkb.layout = "us,ua";
      xkb.options = "grp:alt_shift_toggle";
    };

    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
  };

  # === Звук ===
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # === Пакети ===
  environment.systemPackages = with nixpkgs; [
    firefox
    kdePackages.plasma-workspace
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.kate
    kdePackages.plasma-systemmonitor
    maliit-keyboard
    modemmanager
    usbutils
  ];

  # === Локаль ===
  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "uk_UA.UTF-8";
  console.keyMap = "ua";

  # === Користувач ===
  users.users.vlad = {
    isNormalUser = true;
    password = "1234";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  # === Оптимізація для 32 ГБ ===
  nix.settings = {
    auto-optimise-store = true;
    max-free = lib.mkDefault (3 * 1024 * 1024 * 1024);
    min-free = lib.mkDefault (1 * 1024 * 1024 * 1024);
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.stateVersion = "25.05";
}