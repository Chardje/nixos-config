{inputs,pkgs,...}:
{
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = false; # не працює з 32-bit UEFI
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        devices = [ "nodev" ];
        useOSProber = false;
        target = "i386-efi"; # критично для планшета
        extraConfig = ''
          insmod all_video
        '';
      };
    };

    kernelParams = [
      "intel_idle.max_cstate=1"
      "i915.force_probe=*"
    ];

    initrd.availableKernelModules = [
      "r8723bs" # Wi-Fi
      "i915" # графіка Intel
      "goodix" # сенсор Goodix
      "silead_ts" # сенсор Silead (якщо інший чип)
      "snd_soc_sst_bytcr_rt5640" # звук
    ];

    extraModulePackages = with pkgs.linuxPackages_latest; [ r8723bs ];
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
    opengl.enable = true;
    bluetooth.enable = true;
    enableAllFirmware = true;

    # PipeWire замість PulseAudio
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "intel" ];
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;

      libinput = {
        enable = true;
        touchpad.enable = true;
        touchscreen.enable = true;
      };

      layout = "us,ua";
      xkbOptions = "grp:alt_shift_toggle";
    };

    modemmanager.enable = true;
    # Екранна клавіатура
    onboard.enable = true;
  };

  environment.systemPackages = with pkgs; [
    firefox
    kdeconnect
    networkmanagerapplet
    plasma-workspace
    plasma-disks
    plasma-nm
    xdg-desktop-portal-kde
    onboard
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

  system.stateVersion = "25.05";
}
