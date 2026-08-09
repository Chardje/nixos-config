{
  config,
  pkgs,
  bluettiModule,
  ...
}:
let
in
{
  sops = {
    #age.keyFile = "/home/pi/.config/sops/age/keys.txt";
    secrets."tsl-key" = {
      sopsFile = ../../secrets/nixpi.yaml;
      owner = "root";
      group = "nginx";
      mode = "0440";
    };
    secrets."tsl-crt" = {
      sopsFile = ../../secrets/nixpi.yaml;
      owner = "root";
      group = "nginx";
      mode = "0440";
    };
  };

  # ─── Containers ───────────────────────────────────────────────────────────────

  containers.homeass = {
    autoStart = true;
    extraFlags = [
      "--bind-ro=/etc/resolv.conf:/etc/resolv.conf"
    ];
    privateNetwork = true;
    hostAddress = "192.168.100.1";
    localAddress = "192.168.100.2";
    config =
      { config, pkgs, ... }:
      {
        system.stateVersion = "26.01"; 
        environment.systemPackages = [ pkgs.fribidi ];
        services.home-assistant = {
          enable = true;

          extraPackages =
            python3Packages: with python3Packages; [
              infrared-protocols
            ];
          extraComponents = [
            "default_config"
            "analytics"
            "google_translate"
            "met"
            "radio_browser"
            "shopping_list"
            "isal"
            "infrared"
            "mqtt"
          ];
          config = {
            default_config = { };
            homeassistant = {
              name = "Home";
              latitude = 50.45;
              longitude = 30.52;
              time_zone = "Europe/Kyiv";
              unit_system = "metric";
            };
            http = {
              server_host = "0.0.0.0";
              server_port = 8123;
            };
          };
        };
        networking.firewall.allowedTCPPorts = [ 8123 ];
      };
  };

  containers.mqtt = {
    autoStart = true;
    extraFlags = [
      "--bind-ro=/etc/resolv.conf:/etc/resolv.conf"
    ];
    privateNetwork = true;
    # Same host bridge, different local address
    hostAddress = "192.168.100.1";
    localAddress = "192.168.100.3";
    config =
      { config, pkgs, ... }:
      {
        system.stateVersion = "26.01"; 
        services.mosquitto = {
          enable = true;
          listeners = [
            {
              # Listen on all interfaces inside the container
              address = "0.0.0.0";
              port = 1883;
              settings.allow_anonymous = true;
            }
          ];
        };
        networking.firewall.allowedTCPPorts = [ 1883 ];
      };
  };

  containers.bluetti = {
    autoStart = true;
    extraFlags = [
      "--bind-ro=/etc/resolv.conf:/etc/resolv.conf"
    ];
    privateNetwork = true;
    hostAddress = "192.168.100.1";
    localAddress = "192.168.100.4";
    allowedDevices = [
      # Bluetooth adapter access
      {
        node = "/dev/hci0";
        modifier = "rw";
      }
    ];
    bindMounts = {
      # dbus required for Bluetooth (mirrors host_dbus: true)
      "/run/dbus" = {
        hostPath = "/run/dbus";
        isReadOnly = false;
      };
    };
    config =
      { config, pkgs, ... }:
      {
        system.stateVersion = "26.01"; 
        imports = [
          bluettiModule
        ];

        services.bluetti-mqtt = {
          enable = true;
          # MQTT broker is in the mqtt container
          mqttHost = "192.168.100.3";
          mqttPort = "1883";
          btMac = null; # set your device MAC here after scanning
          scan = true; # enable scan first to discover your device
          pollSec = 30;
          mode = "mqtt";
          haConfig = "normal";
          debug = false;
        };

        # dbus socket for Bluetooth
        #services.dbus.enable = true;

        networking.firewall.enable = false;
      };
  };

  # ─── Host NAT & routing ───────────────────────────────────────────────────────
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  networking.nat = {
    enable = true;
    # All three container interfaces share the same host bridge
    internalInterfaces = [
      "ve-homeass"
      "ve-mqtt"
      "ve-bluetti"
    ];
    externalInterface = "end0";
  };

  # Allow inter-container traffic on the host bridge (192.168.100.0/24)
  networking.firewall.extraCommands = ''
    # Forward traffic between containers
    iptables -A FORWARD -s 192.168.100.0/24 -d 192.168.100.0/24 -j ACCEPT

    # Expose Home Assistant to the outside world
    iptables -t nat -A PREROUTING -p tcp --dport 8123 -j DNAT --to-destination 192.168.100.2:8123
    iptables -A FORWARD -p tcp -d 192.168.100.2 --dport 8123 -j ACCEPT
  '';

  networking.firewall.allowedTCPPorts = [ 8123 ];

  systemd.network.networks."ve-homeass" = { };
  systemd.network.networks."ve-mqtt" = { };
  systemd.network.networks."ve-bluetti" = { };

  services.nginx.virtualHosts."ha.pi.lan" = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."tsl-crt".path;
    sslCertificateKey = config.sops.secrets."tsl-key".path;

    locations."/" = {
      proxyPass = "http://192.168.100.2:8123";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
    };
  };
}
