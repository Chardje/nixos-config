{pkgs, ...}:
let
  pppwn = pkgs.callPackage ../../modules/mypkgs/pppwn.nix { };
in
{
  services.pppwn = {
    enable = false;
    interface = "lan22";
    fw = 1050;
    stage1 = "/pppwn/stage1/stage1.bin";
    stage2 = "/pppwn/stage2/stage2.bin";
    autoRetry = true;
    ambientCapabilities = [
      "CAP_NET_RAW"
      "CAP_NET_ADMIN"
    ];
  };

  systemd.services.pppwn = {
    description = "pppwn daemon (wrapped)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/pppwn -i lan22 --fw 1050 --stage1 /pppwn/stage1/stage1.bin --stage2 /pppwn/stage2/stage2.bin -a "; # підставити правильні args
      AmbientCapabilities = "CAP_NET_RAW CAP_NET_ADMIN";
      CapabilityBoundingSet = "CAP_NET_RAW CAP_NET_ADMIN";
      NoNewPrivileges = "no";
      Restart = "on-failure";
    };
    enable = false;
  };

  # persistent promisc for lan22
  systemd.services.promisc-lan22 = {
    description = "Enable promiscuous mode on lan22 for pppwn";
    after = [ "network.target" ];
    wants = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.iproute2}/bin/ip link set lan22 promisc on";
      ExecStop = "${pkgs.iproute2}/bin/ip link set lan22 promisc off";
      RemainAfterExit = "yes";
    };
    wantedBy = [ "multi-user.target" ];
    enable = false;
  };

  #networking = {
  #  vlans = {
  #    lan22 = {
  #      id = 22;
  #      interface = "end0";
  #    };
  #  };
  #  interfaces = {
  #    # VLAN для другорядної мережі 192.168.22.0/24
  #    lan22 = {
  #      useDHCP = true;
  #    };
  #  };
  #};
}
