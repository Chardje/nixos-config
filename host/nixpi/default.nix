{
  config,
  pkgs,
  lib,
  ...
}:
let
  user = "pi";
  password = "5O3y5cLANb";
  rootpass ="J07eG04xix";
  interface = "end0";
  hostname = "nixpi";  
  mail = "sheiko.vlad@proton.me";
  #  arion = import <arion> {};
  
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  imports = [
    ../../modules/pppwn-service.nix
    #./blocky.nix
    ./books.nix
    ./cockpit.nix
    ./nextcloud.nix
    #./ppwn.nix
    ./qbittorent.nix
    ./samba.nix
    ./ssh.nix
    ./syncthing.nix
    #   <arion/modules/nixos>
  ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = mail;
  security.polkit.enable = true;
  security.pam.services.cockpit.enable = true;

  networking.hosts = {
    "192.168.88.3" = [
      "pi.lan"
      "cockpit.pi.lan"
      "nextcloud.pi.lan"
      "book.pi.lan"
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "uas"
      "usbhid"
      "usbcore"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    loader.timeout = 1;
  };

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="4af551fc-6a55-4451-bdd1-b11090064a2e", RUN+="${pkgs.hdparm}/bin/hdparm -B 180 -S 0 /dev/%k"
  '';

  fileSystems = {
    "/" = {
      device = "/dev/mmcblk0p2";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/mnt/bootdir" = {
      device = "/dev/mmcblk0p1";
      fsType = "vfat";
    };
    "/boot" = {
      fsType = "none";
      device = "/mnt/bootdir/boot";
      options = [ "bind" ];
    };
    "/srv/MyFhdd2T" = {
      device = "/dev/disk/by-uuid/4af551fc-6a55-4451-bdd1-b11090064a2e";
      fsType = "ext4";
      options = [
        "nofail"
        "noatime"
        "defaults"
      ];
    };
  };
  
  networking = {
    hostName = hostname;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
        445
        22
        9090
        8384
        22000
        6881
      ];
      allowedUDPPorts = [
        22
        9090
        22000
        21027
        6881
      ];
    };
  };

  networking.networkmanager.enable = true;
  networking.enableIPv6 = false;
 
  environment.systemPackages = with pkgs; [
    vim
    htop
    git
    docker
    docker-compose
    #filebrowser
    lvm2 # якщо хочеш LVM
    networkmanager
    util-linux
    #cockpit
    #qbittorrent-nox    
    (pkgs.callPackage ../../modules/mypkgs/dockermanager.nix {})
    wget
    libcap
    #pppwn
    iproute2
    #syncthingtray
    #syncthing
    #nginx
  ];

  services.nginx = {
    enable = true;
    logError = "stderr";
    appendHttpConfig = ''
      access_log off;
      map $http_upgrade $connection_upgrade {
        default upgrade;
        "" close;
      }
    '';
  };

  users.groups.shared = { };
  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [
        "wheel"
        "docker"
        "networkmanager"
        "shared"
      ];
    };
    users.root = {
      # можна не вказувати isNormalUser — root вже існує
      password = rootpass;
    };
    
  };

  virtualisation.docker = {
    enable = true;
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.05";
}
