{
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
  ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ce25b217-3550-46a2-a7bb-e818567a58d8";
    fsType = "ext4";
  };

  fileSystems."/data2" = {
    device = "/dev/disk/by-uuid/acf33d6e-5d6a-40cd-b0d9-00ccb34da762";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0E4D-2407";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/976f1678-0cb9-4763-9916-e96c8b9a3631"; }
  ];

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
  powerManagement.cpufreq.min = 100000;
  powerManagement.cpufreq.max = 3000000;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
