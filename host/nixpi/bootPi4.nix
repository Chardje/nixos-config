{pkgs25arm,...}:
{
  boot = {
    kernelPackages = pkgs25arm.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "uas"
      "usbhid"
      "usbcore"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    loader.timeout = 1;
  };
}