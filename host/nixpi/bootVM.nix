{ pkgsStable, ... }:
{
  boot = {
    kernelPackages = pkgsStable.linuxPackages;

    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_blk"
      "virtio_scsi"
      "virtio_net"
      "9p"
      "9pnet_virtio"
      "ext4"
      "xfs"
    ];

    loader = {
      grub = {
        enable = true;
        device = "nodev";
      };
    };

    loader.timeout = 1;
  };
  users.groups.shared = { };
  users = {
    mutableUsers = false;
    users."pi" = {
      isNormalUser = true;
      password = "qwerty";
      extraGroups = [
        "wheel"
        "docker"
        "networkmanager"
        "shared"
      ];
    };
    users.root = {
      password = "test";
    };
  };

  virtualisation.vmVariant = {
    virtualisation.graphics = false;
    virtualisation.diskSize = 10000;
  };
  services.dbus.enable = true;

}
