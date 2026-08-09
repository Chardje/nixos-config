{
  pkgs,
  inputs,
  lib,
  pkgsStable,
  ...
}:
let

in
{
  environment.systemPackages = with pkgs; [
    dnsmasq
    networkmanagerapplet
    # Network tools
    ethtool
    iproute2
    dnsutils
    inetutils
    speedtest-cli
    curl
    bmon
    tcpdump
    wg-netmanager
    wireguard-ui
    
  ];
  networking = {
    # Вимкнути стару мережеву систему
    useDHCP = false;
    nftables.enable = true;
    networkmanager = {
      enable = true;

      # Щоб не чіпав специфічні інтерфейси (важливо для Waydroid)
      unmanaged = [
        "interface-name:waydroid0"
        "interface-name:docker0"
      ];
      insertNameservers = [ "192.168.88.1" ];
    };
  };
  boot.kernelModules = [
    "br_netfilter"
    "ip_tables"
    "iptable_filter"
    "iptable_nat"
    "iptable_mangle"
    "nf_nat"
    "nf_conntrack"
    "x_tables"
    "binder_linux"
    "ashmem_linux"
    "veth"
    "bridge"
  ];
  networking.firewall = {
    enable = true;
    checkReversePath = false;
    # ADD THESE:
    allowedUDPPorts = [
      67
      68
    ]; # DHCP
  };
  security.wrappers.ubridge = {
    source = "${pkgs.ubridge}/bin/ubridge";
    capabilities = "cap_net_admin,cap_net_raw+ep";
    owner = "root";
    group = "root";
  };


  # Ensure dnsmasq is properly configured
  services.dnsmasq = {
    enable = false;
    #settings = {
    #  dhcp-range = "192.168.240.2,192.168.240.254,255.255.255.0,12h";
    #  interface = "waydroid0";
    #  listen-address = "192.168.240.1";
    #};
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
  };
  boot.extraModprobeConfig = ''
    options binder_linux devices=binder,hwbinder,vndbinder
  '';
}
