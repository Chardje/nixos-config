{ ... }:
let
in
{
  systemd.services.syncthing = {
    wants = [ "srv-MyFhdd2T.mount" ];
    after = [ "srv-MyFhdd2T.mount" ];
    #RequiresMountsFor = "/srv/MyFhdd2T";
  };
  services.syncthing = {
    enable = true;
    user = "pi";
    group = "shared";
    dataDir = "/srv/MyFhdd2T/Obsidian";
    configDir = "/home/pi/.config/syncthing";
    guiAddress = "0.0.0.0:8384";
    openDefaultPorts = true; # TCP/UDP 22000, UDP 21027
    settings = {
      devices = {
        "vladpc" = {
          id = "JICPUUU-D7RIJTB-7HCASYM-7C2AXPO-5LRIMVM-QPYK7OR-UVY6PWZ-7WBNPAV";
        };
        "vladphone" = {
          id = "TCEFMCH-4W5SMCO-ADI7K7A-XWUA7EZ-4HAGTPG-HDTBNNT-GV222MT-6OUHEQI";
        };
      };
      folders = {
        "vlad-obsidian" = {
          # Name of folder in Syncthing, also the folder ID
          path = "/srv/MyFhdd2T/Obsidian"; # Which folder to add to Syncthing
          devices = [
            "vladpc"
            "vladphone"
          ]; # Which devices to share the folder with
        };
      };
    };
  };
}
