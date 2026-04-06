{ config, ... }:
let

in
{
  sops = {
    age.keyFile = "/home/pi/.config/sops/age/keys.txt";
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
  systemd.services.arion-calibre-wa = {
    wants = [ "srv-MyFhdd2T.mount" ];
    after = [ "srv-MyFhdd2T.mount" ];

    serviceConfig.RequiresMountsFor = [ "/srv/MyFhdd2T" ];
  };
  services.qbittorrent = {
    enable = true;
    user = "pi";
    group = "shared";

    # Використати готову конфігурацію
    profileDir = "/srv/MyFhdd2T/Shared/";

    # Відкрити вебінтерфейс і порти
    webuiPort = 8080;
    torrentingPort = 6881;
    openFirewall = true;
  };
  networking.firewall.allowedTCPPorts = [ 6881 ];
  networking.firewall.allowedUDPPorts = [ 6881 ];
  services.nginx.virtualHosts."torrent.pi.lan" = {
    # SSL налаштування
    forceSSL = true;
    sslCertificate = config.sops.secrets."tsl-crt".path;
    sslCertificateKey = config.sops.secrets."tsl-key".path;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
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

  systemd.services.qbittorrent.unitConfig = {
    wants = [ "srv-MyFhdd2T.mount" ];
    after = [ "srv-MyFhdd2T.mount" ];
    RequiresMountsFor = "/srv/MyFhdd2T";
  };
}
