# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  pkgs25,
  inputs,
  ...
}:
let
  my-sddm-theme = pkgs.stdenv.mkDerivation rec {
    name = "astronaut-theme";
    src = pkgs.fetchFromGitHub {
      owner = "keyitdev";
      repo = "sddm-astronaut-theme";
      rev = "d73842c761f7d7859f3bdd80e4360f09180fad41";
      sha256 = "1lvbvs58w1jx2y490vb4vpwqs685rl4mnk952945hzcn2dbidppv";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r $src $out/share/sddm/themes/sddm-astronaut-theme

      substituteInPlace \
      $out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop \
      --replace "ConfigFile=Themes/astronaut.conf" \
                "ConfigFile=Themes/pixel_sakura.conf"
    '';
  };
in
{
  system.stateVersion = "25.05";

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./modules/style.nix
    ../../modules/flatpak.nix
    ../../modules/progs-and-pkgs.nix
    inputs.sops-nix.nixosModules.sops
    ./undervolt.nix
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  sops = {
    defaultSopsFile = ../../secrets/for-all.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/vlad/.config/sops/age/keys.txt";
    secrets."samba-credentials" = {
      mode = "0400";
      owner = "root";
      group = "root";
    };
  };
  fileSystems."/home/vlad/smb/Shared" = {
    device = "//pi.lan/Shared";
    fsType = "cifs";
    options = [
      "credentials=${config.sops.secrets."samba-credentials".path}"
      "rw"
      "uid=vlad"
      "gid=users"
      "file_mode=0777"
      "dir_mode=0777"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
    ];
  };

  environment.systemPackages = [
    my-sddm-theme
  ];

  nix.settings = {
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = false;
    efiSupport = true;
    useOSProber = true;
    device = "nodev";
    efiInstallAsRemovable = true;
    theme = "/boot/grub/themes/CyberRe";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [
    "i2c-dev"
    "i2c-core"
    "i2c-i801"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  '';

  networking = {
    hostName = "vladLinux";
    nameservers = [
      "192.168.88.1"
      "1.1.1.1"
    ];
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };
  hardware.graphics = {
    enable = true;
  };
  console = {
    useXkbConfig = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb.layout = "us,ua";
    xkb.options = "grp:alt_shift_toggle";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      #pkgs.xdg-desktop-portal-wlr
      #pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # Використовуємо Hyprland як сесію для входу (Caelestia shell стартує через Home Manager/systemd user)
  services.displayManager.defaultSession = "hyprland";
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs.qt6; [
      qtmultimedia
      qtimageformats
    ];
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
    openDefaultPorts = true;
    settings.devices = {
      "pi" = {
        id = "SJFMVHK-NTZSB6A-DAPW4I2-C5MY3V6-QZNVAIL-YMTXKHU-DG57SNE-PAERBQ4";
      };
    };
    settings.folders = {
      "vlad-obsidian" = {
        # Name of folder in Syncthing, also the folder ID
        path = "/home/vlad/Sync/obsidian"; # Which folder to add to Syncthing
        devices = [
          "pi"
        ]; # Which devices to share the folder with
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.undervolt = {
    enable = false;
  };

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
  services.speechd.enable = true;

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
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
      "text/x-csharp" = "code.desktop";
      "text/x-csharp-source" = "code.desktop";
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

}
