{config,pkgs,lib,...}:
{
services.blocky = {
    enable = false;
    settings = {
      ports.dns = 53; # Port for incoming DNS Queries.
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resol>
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [ "1.1.1.1" "1.0.0.1" ];
      };
      #Enable blocking of certain domains.
      blocking = {
        denylists = {
          #Adblocking
          ads = [
            "https://raw.githubusercontent.com/blocklistproject/Lists/master/ads.txt"
            "https://raw.githubusercontent.com/blocklistproject/Lists/master/tracking.txt"
            "https://raw.githubusercontent.com/blocklistproject/Lists/master/malware.txt"
            "https://raw.githubusercontent.com/blocklistproject/Lists/master/scam.txt"
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/multi.txt"
            "https://small.oisd.nl/domainswild.txt"
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts"
            "https://v.firebog.net/hosts/Easylist.txt"
            "https://v.firebog.net/hosts/Prigent-Ads.txt"
            "https://v.firebog.net/hosts/Prigent-Malware.txt"
            "https://pgl.yoyo.org/adservers/serverlist.php"
          ];
          #Another filter for blocking adult sites
          adult = [ "https://blocklistproject.github.io/Lists/porn.txt" ];
          #You can add additional categories
        };
        allowlists = {
        };
        #Configure what block categories are used
        clientGroupsBlock = {
          default = [ "ads"];
        };
      };
    };
  };
}
