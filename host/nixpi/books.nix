{ config, ... }:
let
  cwa-port = "8083";
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
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers = {
    calibre-wa = {
      image = "crocodilestick/calibre-web-automated:latest";

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "UTC";
        NETWORK_SHARE_MODE = "false";
        CWA_PORT_OVERRIDE = toString cwa-port;
      };

      volumes = [
        "/srv/MyFhdd2T/calibre/config:/config"
        "/srv/MyFhdd2T/Shared/books-ingest:/cwa-book-ingest"
        "/srv/MyFhdd2T/calibre/library:/calibre-library"
        "/srv/MyFhdd2T/calibre/plugins:/config/.config/calibre/plugins"
      ];

      ports = [
        "${toString cwa-port}:${toString cwa-port}"
      ];
      extraOptions = [
        "--name=calibre-web-automated"
        "--no-healthcheck"
      ];
    };
  };
  # залежність від монтування
  systemd.services."podman-calibre-wa" = {
    wants = [ "srv-MyFhdd2T.mount" ];
    after = [ "srv-MyFhdd2T.mount" ];

    serviceConfig.RequiresMountsFor = [ "/srv/MyFhdd2T" ];
  };

  services.nginx.virtualHosts."books.pi.lan" = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."tsl-crt".path;
    sslCertificateKey = config.sops.secrets."tsl-key".path;

    locations."/" = {
      proxyPass = "http://127.0.0.1:8083";
      proxyWebsockets = true;

      extraConfig = ''
        proxy_buffering off;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Upgrade $http_upgrade;
      '';
    };
  };
}
