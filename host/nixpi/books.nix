{...}:
let 
  cwa-port = "8083";
in {
  sops={
    defaultSopsFile = ../../secrets/nixpi.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/pi/.config/sops/age/keys.txt";
    secrets."samba-credentials" = {
      mode = "0400";
      owner = "root";
      group = "root";
    };
    secrets."tsl-key" = {};
    secrets."tsl-crt" = {};
  };
  virtualisation.arion = {
   backend = "docker";
   projects = {
     "calibre-wa" = {
       settings.services."calibre-wa".service = {
         image = "crocodilestick/calibre-web-automated:latest";
         container_name = "calibre-web-automated";
         restart = "unless-stopped";
  
         environment = {
           PUID = "1000";
           PGID = "1000";
           TZ = "UTC";
           #HARDCOVER_TOKEN = "your_hardcover_api_key_here";
           NETWORK_SHARE_MODE = "false";
           CWA_PORT_OVERRIDE = cwa-port;
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
  
         # Якщо порт <1024 — розкоментуй
         # cap_add = [ "NET_BIND_SERVICE" ];
       };
     };
   };
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
