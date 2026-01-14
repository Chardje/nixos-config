{...}:
let

in{
  systemd.services.samba-smbd = {
    wants = [ "srv-MyFhdd2T.mount" ];
    after = [ "srv-MyFhdd2T.mount" ];
    #RequiresMountsFor = "/srv/MyFhdd2T";
  };
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "NixOS Samba Server";
        security = "user";
        "map to guest" = "Bad User";
        "force group" = "shared";
        "create mask" = "0660";
        "directory mask" = "2770";
      };

      "Shared" = {
        "path" = "/srv/MyFhdd2T/Shared";
        "browseable" = "yes";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = "pi";
      };

    };
  };
}