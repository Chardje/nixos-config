{...}:
let
  
in{
  environment.pathsToLink = [ "/share/cockpit" ];

  services.cockpit = {
    enable = true;
    openFirewall = false;
    port = 9090;
    allowed-origins = [
      "https://pi.lan"
      "https://pi.lan:443"
      "https://192.168.88.3:9090"
      "https://cockpit.pi.lan"
    ];
    settings = {
      WebService = {
      };
    };
  };
  services.nginx.virtualHosts."cockpit.pi.lan" = {
    forceSSL = true;
    sslCertificate = "/var/lib/nginx-ssl/pi.lan.crt";
    sslCertificateKey = "/var/lib/nginx-ssl/pi.lan.key";

    locations."/" = {
      proxyPass = "http://127.0.0.1:9090";
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
