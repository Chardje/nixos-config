{ config, ... }:
let
  fireflyHost = "firefly.pi.lan";
  importerHost = "firefly-importer.pi.lan";
  fireflyDataDir = "/srv/MyFhdd2T/firefly";
  fireflySync = "firefly-sync.pi.lan";

  fireflyUser = {
    users.users.firefly = {
      isSystemUser = true;
      group = "firefly";
      uid = 4300;
    };
    users.groups.firefly = {
      gid = 4300;
    };
  };

  fireflyLocales = [
    "uk_UA.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  tlsVhost = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."tsl-crt".path;
    sslCertificateKey = config.sops.secrets."tsl-key".path;
  };
in
{
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "end0";
    enableIPv6 = true;
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  imports = [ fireflyUser ];

  systemd.tmpfiles.rules = [
    "d ${fireflyDataDir} 0750 firefly firefly - -"
    "d ${fireflyDataDir}/iii 0750 firefly firefly - -"
    "d ${fireflyDataDir}/importer 0750 firefly firefly - -"
  ];

  sops = {
    secrets."firefly-iii-app-key" = {
      sopsFile = ../../secrets/nixpi.yaml;
      owner = "firefly";
      group = "firefly";
      mode = "0400";
    };
    secrets."firefly-iii-importer-client-id" = {
      sopsFile = ../../secrets/nixpi.yaml;
      owner = "root";
      group = "root";
      mode = "0400";
    };
    secrets."firefly-iii-bank-sync-monobank-token" = {
      sopsFile = ../../secrets/nixpi.yaml;
      owner = "root";
      group = "root";
      mode = "0400";
    };
    secrets."firefly-iii-bank-sync-ffi-token" = {
      sopsFile = ../../secrets/nixpi.yaml;
      owner = "root";
      group = "root";
      mode = "0400";
    };
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

  containers.firefly-iii = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    bindMounts = {
      "/var/lib/firefly-iii" = {
        hostPath = "${fireflyDataDir}/iii";
        isReadOnly = false;
      };
      "/run/secrets/firefly-iii-app-key" = {
        hostPath = config.sops.secrets."firefly-iii-app-key".path;
        isReadOnly = true;
      };
    };
    config =
      { pkgs, ... }:
      {
        system.stateVersion = "25.05";
        imports = [ fireflyUser ];
        i18n.supportedLocales = fireflyLocales;

        services.firefly-iii = {
          enable = true;
          package = pkgs.firefly-iii;
          dataDir = "/var/lib/firefly-iii";
          enableNginx = true;
          virtualHost = fireflyHost;
          user = "firefly";
          group = "nginx";
          settings = {
            APP_ENV = "production";
            APP_DEBUG = "false";
            APP_URL = "https://${fireflyHost}";
            APP_KEY_FILE = "/run/secrets/firefly-iii-app-key";
            DB_CONNECTION = "sqlite";
            DB_DATABASE = "/var/lib/firefly-iii/storage/database/database.sqlite";
            LOG_CHANNEL = "stderr";
            TRUSTED_PROXIES = "127.0.0.1,::1,192.168.100.10";
            TZ = "Europe/Kyiv";
          };
        };
        services.nginx.virtualHosts.${fireflyHost}.listen = [
          {
            addr = "0.0.0.0";
            port = 8080;
          }
        ];
        networking.firewall.allowedTCPPorts = [ 8080 ];
        environment.systemPackages = [ pkgs.curl ];
      };
  };

  containers.firefly-iii-data-importer = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.20";
    localAddress = "192.168.100.21";
    bindMounts = {
      "${fireflyDataDir}/importer" = {
        hostPath = "${fireflyDataDir}/importer";
        isReadOnly = false;
      };
      "/run/secrets/firefly-iii-importer-client-id" = {
        hostPath = config.sops.secrets."firefly-iii-importer-client-id".path;
        isReadOnly = true;
      };
    };
    config =
      { pkgs, ... }:
      {
        system.stateVersion = "25.05";
        imports = [ fireflyUser ];
        i18n.supportedLocales = fireflyLocales;

        services.firefly-iii-data-importer = {
          enable = true;
          package = pkgs.firefly-iii-data-importer;
          dataDir = "/var/lib/firefly-iii-data-importer";
          enableNginx = true;
          virtualHost = importerHost;
          user = "firefly";
          group = "nginx";
          settings = {
            APP_ENV = "production";
            APP_DEBUG = "false";
            FIREFLY_III_URL = "http://192.168.100.11:8080";
            VANITY_URL = "https://${fireflyHost}";
            FIREFLY_III_CLIENT_ID_FILE = "/run/secrets/firefly-iii-importer-client-id";
            TRUSTED_PROXIES = "127.0.0.1,::1,192.168.100.20";
            APP_URL = "https://${importerHost}";
            ASSET_URL = "https://${importerHost}";
            ENABLE_EXTERNAL_SCRIPTS = "true";
          };
        };
        services.nginx.virtualHosts.${importerHost}.listen = [
          {
            addr = "0.0.0.0";
            port = 8080;
          }
        ];
        networking.firewall.allowedTCPPorts = [ 8080 ];
      };
  };

  sops.templates."firefly-bank-sync.env".content = ''
  MONOBANK_API_TOKEN=${config.sops.placeholder."firefly-iii-bank-sync-monobank-token"}
  FFI_TOKEN=${config.sops.placeholder."firefly-iii-bank-sync-ffi-token"}
'';

services.firefly-iii-bank-sync = {
  enable = true;
  listenAddress = "127.0.0.1:3000";
  logLevel = "info";
  monobankApiToken = "placeholder-overridden-by-EnvironmentFile";
  fbsHost = "https://${fireflyHost}";
  ffiToken = "placeholder-overridden-by-EnvironmentFile";
  ffiUrl = "https://${fireflyHost}";
  openFirewall = false;
};

systemd.services.firefly-iii-bank-sync.serviceConfig.EnvironmentFile = [
  config.sops.templates."firefly-bank-sync.env".path
];

  services.nginx.virtualHosts.${fireflyHost} = tlsVhost // {
    locations."/" = {
      proxyPass = "http://192.168.100.11:8080";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };
  services.nginx.virtualHosts.${fireflySync} = tlsVhost // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };

  services.nginx.virtualHosts.${importerHost} = tlsVhost // {
    locations."/" = {
      proxyPass = "http://192.168.100.21:8080";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };
}
