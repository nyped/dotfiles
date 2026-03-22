{
  inputs,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    kernelModules = [
      "libcomposite"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelParams = [
      "usb-storage.quirks=152d:0583:u"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  swapDevices = [
    {
      device = "/.swapfile";
      size = 8 * 1024;
    }
  ];

  hardware.raspberry-pi."4" = {
    tc358743.enable = true;
    dwc2 = {
      enable = true;
      dr_mode = "peripheral";
    };
  };

  hardware.enableRedistributableFirmware = true;
  nixpkgs.hostPlatform.system = "aarch64-linux";

  # Gadgets before docker
  systemd.services.kvm_gadgets = {
    description = "kvm gadgets register";
    script = builtins.readFile ./gadgets.sh;
    requiredBy = [ "docker.service" ];
  };
}
