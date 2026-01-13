{ ... }:
let

in
{
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
  systemd.services.nextcloud-setup = {
    wants = [ "srv-MyFhdd2T.mount" ];
    after = [ "srv-MyFhdd2T.mount" ];
    serviceConfig = {
      RequiresMountsFor = [ "/srv/MyFhdd2T" ];
    };
  };
  systemd.services.nextcloud-phpfpm = {
    wants = [ "srv-MyFhdd2T.mount" ];
    after = [ "srv-MyFhdd2T.mount" ];
  };

  services.nextcloud = {
    enable = true;
    home = "/var/lib/nextcloud";
    datadir = "/srv/MyFhdd2T/";

    hostName = "nextcloud.pi.lan";

    https = true;
    config = {
      adminpassFile = "/etc/nextcloud/admin.pass";
      dbtype = "sqlite";
    };
    settings = {
      trusted_domains = [ "nextcloud.pi.lan" ];
      overwriteprotocol = "https";
      loglevel = 1;
      log_type = "file";
      default_phone_region = "UA";
    };

    maxUploadSize = "2G";

    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
      "opcache.max_accelerated_files" = "10000";
      "opcache.memory_consumption" = "128";
      "opcache.revalidate_freq" = "1";
      "opcache.fast_shutdown" = "1";
    };

    enableImagemagick = true;

  };

  # Додаткові налаштування для nginx virtualHost Nextcloud
  services.nginx.virtualHosts."nextcloud.pi.lan" = {
    # SSL налаштування
    forceSSL = true;
    sslCertificate = config.sops.secrets."tsl-crt".path;
    sslCertificateKey = config.sops.secrets."tsl-key".path;
    
  };
  users.users.nextcloud = {
    extraGroups = [ "shared" ];
  };
}
