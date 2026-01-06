{...}:
let 
  cwa-port = "8083";
in {
  # virtualisation.arion = {
  #  backend = "docker";
  #  projects = {
  #    "calibre-wa" = {
  #      settings.services."calibre-wa".service = {
  #        image = "crocodilestick/calibre-web-automated:latest";
  #        container_name = "calibre-web-automated";
  #        restart = "unless-stopped";
  #
  #        environment = {
  #          PUID = "1000";
  #          PGID = "1000";
  #          TZ = "UTC";
  #          #HARDCOVER_TOKEN = "your_hardcover_api_key_here";
  #          NETWORK_SHARE_MODE = "false";
  #          CWA_PORT_OVERRIDE = cwa-port;
  #        };
  #
  #        volumes = [
  #          "/srv/MyFhdd2T/calibre/config:/config"
  #          "/srv/MyFhdd2T/Shared/books-ingest:/cwa-book-ingest"
  #          "/srv/MyFhdd2T/calibre/library:/calibre-library"
  #          "/srv/MyFhdd2T/calibre/plugins:/config/.config/calibre/plugins"
  #        ];
  #
  #        ports = [
  #          "{cwa-port}:{cwa-port}"
  #        ];
  #
  #        # Якщо порт <1024 — розкоментуй
  #        # cap_add = [ "NET_BIND_SERVICE" ];
  #      };
  #    };
  #  };
  #};
  services.nginx.virtualHosts."books.pi.lan" = {
    forceSSL = true;
    sslCertificate = "/var/lib/nginx-ssl/pi.lan.crt";
    sslCertificateKey = "/var/lib/nginx-ssl/pi.lan.key";

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
