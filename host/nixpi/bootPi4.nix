{ pkgsStableArm, ... }:
{
  boot = {
    loader = {
      timeout = 2; 
      generic-extlinux-compatible.enable = true;
      
      # Якщо використовується специфічний модуль RPi (залежно від версії NixOS):
      # raspberryPi.enable = true;
      # raspberryPi.version = "4";
    };
    #kernelPackages = pkgsStableArm.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "uas"
      "usbhid"
      "usbcore"
      "dm_mod"
    ];
    kernelModules =[ "dm_mod" ];
    initrd.systemd.tpm2.enable = false;
    initrd.includeDefaultModules = true;
    initrd.services.lvm.enable = true;
  };
  #hardware.deviceTree.enable = true;
}
