{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages;

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

  virtualisation.vmVariant = {
    virtualisation.graphics = false;
  };
}
