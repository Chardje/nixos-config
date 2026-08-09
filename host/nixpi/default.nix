{
  config,
  pkgs,
  lib,
  #inputs,
  ...
}:
let
  user = "pi";
  interface = "end0";
  hostname = "nixpi";

in
{
nixpkgs.config.permittedInsecurePackages = [
  "docker-28.5.2"
];
  sops = {
    defaultSopsFile = ../../secrets/for-all.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets."samba-credentials" = {
      mode = "0400";
      owner = "root";
      group = "root";
    };
    secrets."pi-user-password-hash" = {
      sopsFile = ../../secrets/nixpi.yaml;
      owner = "root";
      group = "root";
      mode = "0400";
      neededForUsers = true;
    };
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  imports = [
    #../../modules/pppwn-service.nix
    #./blocky.nix
    ./books.nix
    ./cockpit.nix
    ./firefly.nix
    ./nextcloud.nix
    #./ppwn.nix
    ./qbittorent.nix
    ./samba.nix
    ./ssh.nix
    ./syncthing.nix
    #./home-assistant.nix
    #./matrix.nix
    #inputs.sops-nix.nixosModules.sops
  ];

  security.acme.acceptTerms = true;
  security.polkit.enable = true;
  security.pam.services.cockpit.enable = true;

  networking.hosts = {
    "192.168.88.3" = [
      "pi.lan"
      "cockpit.pi.lan"
      "firefly.pi.lan"
      "firefly-importer.pi.lan"
      "firefly-sync.pi.lan" 
      "nextcloud.pi.lan"
      "book.pi.lan"
      "ha.pi.lan"
      "torrent.pi.lan"
    ];
  };

  #networking.interfaces.end0.useDHCP = true;

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="4af551fc-6a55-4451-bdd1-b11090064a2e", RUN+="${pkgs.hdparm}/bin/hdparm -B 140 -S 0 /dev/%k"
  '';

  fileSystems = {
    "/" = {
      device = "/dev/mmcblk0p2";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/boot" = {
      device = "/dev/mmcblk0p1";
      fsType = "vfat";
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
      ];
      allowedUDPPorts = [
        22
        9090
      ];
    };
  };

  networking.networkmanager.enable = false;
  networking.interfaces.end0.useDHCP = false; # ← вимкни DHCP
  networking.interfaces.end0.ipv4.addresses = [
    {
      address = "192.168.88.3";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.88.1"; # ← додай gateway
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  environment.systemPackages = with pkgs; [
    vim
    neovim
    htop
    git
    docker
    docker-compose
    #filebrowser
    #networkmanager
    util-linux
    #(pkgs.callPackage ../../modules/mypkgs/dockermanager.nix {})
    wget
    libcap
    #pppwn
    iproute2
    sops
    lvm2
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
      hashedPasswordFile = config.sops.secrets."pi-user-password-hash".path;

      extraGroups = [
        "wheel"
        "docker"
        "networkmanager"
        "shared"
      ];
    };
    users.root = {
      #password = "test";
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.05";
}
