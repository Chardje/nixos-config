{ config, pkgs25, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # === ISO ===
  isoImage = {
    isoBaseName = lib.mkForce "pixus-nixos";
    isoName = lib.mkForce "pixus-nixos.iso";
    volumeID = lib.mkForce "PIXUS";
    makeEfiBootable = true;
    makeUsbBootable = true;
    appendToMenuLabel = lib.mkForce " Pixus";
  };

  # === Файлові системи ===
  boot.supportedFilesystems = lib.mkForce [ "vfat" "ext4" "ntfs" "exfat" ];

  # === Ядро ===
  boot.kernelPackages = lib.mkForce pkgs25.linuxPackages_6_6;
  boot.kernelParams = lib.mkAfter [ "intel_idle.max_cstate=1" "i915.force_probe=*" ];
  boot.initrd.availableKernelModules = lib.mkAfter [ "i915" "cdc_acm" "rtsx_pci_sdmmc" ];

  # === Мережа ===
  networking.hostName = lib.mkForce "pixus-live";

  # === Графіка ===
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs25; [ intel-media-driver intel-vaapi-driver ];
  };
  hardware.firmware = with pkgs25; [ linux-firmware ];
  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;

  # === Plasma 6 (БЕЗ plasma5) ===
  services.desktopManager.plasma6.enable = true;
  # ВИДАЛЕНО: services.xserver.desktopManager.plasma5.enable = lib.mkForce false;

  # === Вимкнути Wayland ===
  services.displayManager.sddm.wayland.enable = lib.mkForce false;

  # === Українська ===
  services.xserver.xkb.layout = lib.mkForce "us,ua";
  services.xserver.xkb.options = lib.mkForce "grp:alt_shift_toggle";
  time.timeZone = lib.mkForce "Europe/Kyiv";
  i18n.defaultLocale = lib.mkForce "uk_UA.UTF-8";
  console.keyMap = lib.mkForce "ua";

  # === PipeWire ===
  hardware.pulseaudio.enable = lib.mkForce false;
  services.pulseaudio.enable = lib.mkForce false;  # залиш, бо базовий модуль його використовує

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # === Пакети ===
  environment.systemPackages = with pkgs25; [
    vim git wget curl htop
    modemmanager usbutils
    maliit-keyboard
    kdePackages.partitionmanager
    gparted
  ];

  # === Автологін ===
  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };

  # === Оптимізація ===
  nix.settings.auto-optimise-store = true;

  system.stateVersion = "25.05";
}