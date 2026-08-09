# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://nixos.org/manual/nixos/stable/, and in the NixOS channel.

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./minecraft-servers.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Networking
  networking.hostName = "laptop"; # Змініть на свій
  networking.networkmanager.enable = true; # або wicked, або просто DHCP
  networking.nameservers = [ "192.168.88.1" ];
  networking.interfaces.enp7s0.ipv4 = {
    addresses = [
      {
        address = "192.168.88.15";
        prefixLength = 24;
      }
      {
        address = "192.168.50.2";
        prefixLength = 24;
      }
    ];
    routes = [
      {
        address = "192.168.50.0";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = "192.168.88.1";
  # Set your time zone.
  time.timeZone = "Europe/Kiev"; # або ваша зона

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (для ноутбуків)
  services.libinput.enable = true;
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    vscode
    neovim
    tmux
    #vimPlugins.LazyVim
  ];
  programs.firefox.enable = true;

  services.logind = {
    lidSwitch = "suspend"; # коли від батареї — засипати
    lidSwitchExternalPower = "ignore";
  };

  users.users.laptop = {
    isNormalUser = true;
    description = "laptop";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      AllowUsers = [ "laptop" ];
      PubkeyAuthentication = true;
    };
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "26.05";
}
