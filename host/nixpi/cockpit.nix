{...}:
let
  
in{
  environment.pathsToLink = [ "/share/cockpit" ];
  sops={
    defaultSopsFile = ./secrets/nixpi.yaml;
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
    
    sslCertificate = config.sops.secrets."tsl-crt".path;
    sslCertificateKey = config.sops.secrets."tsl-key".path;
    
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
